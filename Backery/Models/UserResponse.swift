//
//  UserResponse.swift
//  Backery
//
//  Created by Shamam Alkafri on 26/01/2025.
//

import Foundation

struct UserResponse: Codable {
    let id: String
    let name: String
    let email: String
    let avatar: String
    let token: String
}
