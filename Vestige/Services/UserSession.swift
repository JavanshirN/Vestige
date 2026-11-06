//
//  UserSession.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 05.11.26.
//


import Foundation

enum UserSession {
    private static let nameKey = "userName"
    private static let emailKey = "userEmail"
    
    static var name: String {
        UserDefaults.standard.string(forKey: nameKey) ?? ""
    }
    
    static var email: String {
        UserDefaults.standard.string(forKey: emailKey) ?? ""
    }
    
    static func save(name: String, email: String) {
        UserDefaults.standard.set(name, forKey: nameKey)
        UserDefaults.standard.set(email, forKey: emailKey)
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: nameKey)
        UserDefaults.standard.removeObject(forKey: emailKey)
    }
}
