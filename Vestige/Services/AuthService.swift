//
//  AuthService.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 05.11.26.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthService {

    static let shared = AuthService()

    private init() {}

    private let db = Firestore.firestore()

    private let isLoggedInKey = "isLoggedIn"
    private let userIDKey = "loggedInUserID"

    var isLoggedIn: Bool {
        guard let user = Auth.auth().currentUser else {
            UserDefaults.standard.set(false, forKey: isLoggedInKey)
            UserDefaults.standard.removeObject(forKey: userIDKey)
            return false
        }

        UserDefaults.standard.set(true, forKey: isLoggedInKey)
        UserDefaults.standard.set(user.uid, forKey: userIDKey)

        return true
    }

    var currentUser: User? {
        guard let firebaseUser = Auth.auth().currentUser else {
            return nil
        }

        return User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? "Friend",
            email: firebaseUser.email ?? "",
            photoURL: firebaseUser.photoURL?.absoluteString
        )
    }

    private func saveLoginSession() {
        guard let user = Auth.auth().currentUser else { return }

        UserDefaults.standard.set(true, forKey: isLoggedInKey)
        UserDefaults.standard.set(user.uid, forKey: userIDKey)
    }

    func register(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let firebaseUser = result?.user else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }

            let changeRequest = firebaseUser.createProfileChangeRequest()
            changeRequest.displayName = name

            changeRequest.commitChanges { _ in

                guard let user = AuthService.shared.currentUser else {
                    DispatchQueue.main.async {
                        completion(.failure(URLError(.badServerResponse)))
                    }
                    return
                }

                AuthService.shared.saveLoginSession()

                AuthService.shared.saveUser(user) { saveError in
                    if let saveError = saveError {
                        print("SAVE USER ERROR:", saveError)
                    }

                    DispatchQueue.main.async {
                        completion(.success(user))
                    }
                }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in

            DispatchQueue.main.async {

                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let user = AuthService.shared.currentUser else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }

                AuthService.shared.saveLoginSession()
                AuthService.shared.syncUserDocument()
                completion(.success(user))
            }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()

        UserDefaults.standard.set(false, forKey: isLoggedInKey)
        UserDefaults.standard.removeObject(forKey: userIDKey)
    }

    private func saveUser(_ user: User, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("users").document(user.id).setData(data) { error in
            completion(error)
        }
    }

    func syncUserDocument() {
        guard let user = currentUser else { return }

        db.collection("users").document(user.id).setData([
            "id": user.id,
            "name": user.name,
            "email": user.email
        ], merge: true)
    }

    func updateName(_ name: String, completion: @escaping (Error?) -> Void) {
        guard let firebaseUser = Auth.auth().currentUser else {
            completion(URLError(.userAuthenticationRequired))
            return
        }

        let changeRequest = firebaseUser.createProfileChangeRequest()
        changeRequest.displayName = name

        changeRequest.commitChanges { [weak self] error in
            if let error = error {
                DispatchQueue.main.async { completion(error) }
                return
            }

            self?.db.collection("users").document(firebaseUser.uid).setData(["name": name], merge: true) { saveError in
                if let saveError = saveError {
                    print("UPDATE NAME ERROR:", saveError)
                }
                DispatchQueue.main.async { completion(nil) }
            }
        }
    }

    func changePassword(
        currentPassword: String,
        newPassword: String,
        completion: @escaping (Error?) -> Void
    ) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(URLError(.userAuthenticationRequired))
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        user.reauthenticate(with: credential) { _, error in
            if error != nil {
                let wrongPassword = NSError(
                    domain: "Vestige",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Current password is wrong."]
                )
                DispatchQueue.main.async { completion(wrongPassword) }
                return
            }

            user.updatePassword(to: newPassword) { error in
                DispatchQueue.main.async { completion(error) }
            }
        }
    }
}
