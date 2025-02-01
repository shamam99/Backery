//
//  BackeryApp.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import SwiftUI

@main
struct BackeryApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            print("Token loaded: \(token)")
        } else {
            print("No token found. User not logged in.")
        }
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                MainTabView()
            } else {
                SplashView()
            }
        }
    }
}
