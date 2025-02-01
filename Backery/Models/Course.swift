//
//  Course.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import Foundation

struct Course: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let chef: String
    let level: String
    let date: String
    let time: String
    let location: String
    let image: String? 
}
