//
//  User.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import Foundation

struct User: Decodable {
    var id: String
    var name: String
    var email: String
    var avatar: String
    var token: String?
}
