//
//  HomeViewModel.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var popularCourses: [Course] = []
    @Published var upcomingCourses: [Course] = []
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""

    func fetchPopularCourses() {
        APIManager.shared.fetch(endpoint: "/courses") { (result: Result<[Course], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let courses):
                    self.popularCourses = courses
                case .failure(let error):
                    self.errorMessage = "Failed to fetch popular courses: \(error.localizedDescription)"
                }
            }
        }
    }

    func fetchUpcomingCourses() {
        guard let userId = UserDefaults.standard.string(forKey: "userID") else { return }
        APIManager.shared.fetch(endpoint: "/bookings/user/\(userId)") { (result: Result<[Course], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let courses):
                    self.upcomingCourses = courses.filter { $0.dateAsDate > Date() }
                case .failure:
                    self.upcomingCourses = []
                }
            }
        }
    }
}

// Helper Extension for Date Parsing
extension Course {
    var dateAsDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: date) ?? Date.distantPast
    }
}
