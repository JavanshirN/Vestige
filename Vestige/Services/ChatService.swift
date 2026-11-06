//
//  ChatService.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 05.11.26.
//


import Foundation
import FirebaseFirestore

struct ChatMessage {
    let id: String
    let senderID: String
    let text: String
    let date: Date
}

final class ChatService {

    static let shared = ChatService()

    private init() {}

    private let db = Firestore.firestore()

    private func chatID(_ firstID: String, _ secondID: String) -> String {
        [firstID, secondID].sorted().joined(separator: "_")
    }

    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let myID = AuthService.shared.currentUser?.id else {
            completion(.success([]))
            return
        }

        AuthService.shared.syncUserDocument()

        db.collection("users").getDocuments(source: .server) { snapshot, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            let users: [User] = (snapshot?.documents ?? [])
                .compactMap { document in
                    let data = document.data()
                    let id = (data["id"] as? String) ?? document.documentID

                    guard id != myID else { return nil }

                    return User(
                        id: id,
                        name: data["name"] as? String ?? "Friend",
                        email: data["email"] as? String ?? "",
                        photoURL: nil
                    )
                }
                .sorted { $0.name.lowercased() < $1.name.lowercased() }

            DispatchQueue.main.async { completion(.success(users)) }
        }
    }

    func listenMessages(with otherID: String, onChange: @escaping ([ChatMessage]) -> Void) -> ListenerRegistration?{
        guard let myID = AuthService.shared.currentUser?.id else { return nil }

        return db.collection("chats")
            .document(chatID(myID, otherID))
            .collection("messages")
            .order(by: "createdAt")
            .addSnapshotListener { snapshot, _ in
                let messages = (snapshot?.documents ?? []).map { document -> ChatMessage in
                    let data = document.data(with: .estimate)
                    let timestamp = data["createdAt"] as? Timestamp

                    return ChatMessage(
                        id: document.documentID,
                        senderID: data["senderID"] as? String ?? "",
                        text: data["text"] as? String ?? "",
                        date: timestamp?.dateValue() ?? Date()
                    )
                }

                DispatchQueue.main.async {
                    onChange(messages)
                }
            }
    }

    func send(text: String, to otherID: String) {
        guard let myID = AuthService.shared.currentUser?.id else { return }

        let chatRef = db.collection("chats").document(chatID(myID, otherID))

        chatRef.setData([
            "participants": [myID, otherID],
            "lastMessage": text,
            "updatedAt": FieldValue.serverTimestamp()
        ], merge: true)

        chatRef.collection("messages").addDocument(data: [
            "senderID": myID,
            "text": text,
            "createdAt": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("SEND MESSAGE ERROR:", error)
            }
        }
    }
}
