//
//  HomeViewModel.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 11.10.26.
//


import Foundation

final class HomeViewModel {

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            return "Good morning,"
        case 12..<17:
            return "Good afternoon,"
        case 17..<22:
            return "Good evening,"
        default:
            return "Good night,"
        }
    }

    var userName: String {
        return "Javanshir"
    }
}
