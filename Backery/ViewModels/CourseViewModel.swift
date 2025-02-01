//
//  CourseViewModel.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import Foundation

class CourseViewModel: ObservableObject {
    @Published var courses: [Course] = [] // Holds all courses fetched from the backend
    @Published var filteredCourses: [Course] = [] // For search functionality
    @Published var searchText: String = ""
    @Published var errorMessage: String? = nil

    func fetchCourses() {
        print("Fetching courses...")
        APIManager.shared.fetch(endpoint: "/courses") { (result: Result<[Course], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let courses):
                    print("Courses fetched successfully: \(courses)")
                    self.courses = courses
                    self.filterCourses()
                case .failure(let error):
                    print("Error fetching courses: \(error.localizedDescription)")
                    self.errorMessage = "Failed to fetch courses: \(error.localizedDescription)"
                }
            }
        }
    }

    func filterCourses() {
        if searchText.isEmpty {
            filteredCourses = courses
        } else {
            filteredCourses = courses.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
