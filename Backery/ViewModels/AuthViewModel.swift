//
//  AuthViewModel.swift
//  Backery
//


import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: User?

    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let loginData = ["email": email, "password": password]

        // Encode request body
        guard let requestBody = try? JSONSerialization.data(withJSONObject: loginData) else {
            completion(false, "Failed to encode request body.")
            return
        }

        // API call to backend for login
        APIManager.shared.create(endpoint: "/users/login", body: requestBody) { (result: Result<UserResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // Save token and user details in UserDefaults
                    UserDefaults.standard.set(response.token, forKey: "userToken")
                    if let encodedUser = try? JSONEncoder().encode(response) {
                        UserDefaults.standard.set(encodedUser, forKey: "userDetails")
                    }

                    self.isLoggedIn = true
                    self.user = User(id: response.id, name: response.name, email: response.email, avatar: response.avatar)
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
        }
    }

    func logout() {
        // Clear stored user data and token
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "userDetails")
        isLoggedIn = false
        user = nil
    }

    func fetchUser() {
        // Fetch user details from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "userDetails"),
           let decodedUser = try? JSONDecoder().decode(User.self, from: data) {
            self.user = decodedUser
        }
    }

    func isTokenValid() -> Bool {
        // Check if a token exists
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            return !token.isEmpty
        }
        return false
    }

    func validateSession() {
        // Check if the user is logged in by verifying the token
        if isTokenValid() {
            fetchUser()
            self.isLoggedIn = true
        } else {
            logout()
        }
    }
}
