//
//  ProfileViewModel.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import SwiftUI

// to Handle Decodable for Empty Responses
struct EmptyResponse: Decodable {}

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var bookedCourses: [Course] = []

    // Fetch User Details
    func fetchUser() {
        if let userData = UserDefaults.standard.data(forKey: "userDetails") {
            user = try? JSONDecoder().decode(User.self, from: userData)
        }
    }

    // Fetch Booked Courses
    func fetchBookedCourses() {
        guard let userId = UserDefaults.standard.string(forKey: "userID") else { return }
        APIManager.shared.fetch(endpoint: "/bookings/user/\(userId)") { (result: Result<[Course], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let courses):
                    self.bookedCourses = courses
                case .failure:
                    self.bookedCourses = []
                }
            }
        }
    }

    // Cancel a Booking
    func cancelBooking(courseId: String, completion: @escaping (Bool, String) -> Void) {
        APIManager.shared.delete(endpoint: "/bookings/\(courseId)") { (result: Result<Bool, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.bookedCourses.removeAll { $0.id == courseId }
                    completion(true, "Booking canceled successfully.")
                case .failure:
                    completion(false, "Failed to cancel booking.")
                }
            }
        }
    }
    
    // Update User Name
    func updateUserName(newName: String, completion: @escaping (Bool, String) -> Void) {
        guard let userId = user?.id else {
            completion(false, "User ID not found.")
            return
        }

        let updateData = ["name": newName]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: updateData) else {
            completion(false, "Failed to encode data.")
            return
        }

        APIManager.shared.update(endpoint: "/users/\(userId)", body: jsonData) { (result: Result<EmptyResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.user?.name = newName
                    completion(true, "Name updated successfully.")
                case .failure(let error):
                    completion(false, "Failed to update name: \(error.localizedDescription)")
                }
            }
        }
    }
}
