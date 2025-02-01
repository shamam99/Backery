//
//  BookingViewModel.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import Foundation

class BookingViewModel: ObservableObject {
    @Published var bookings: [Booking] = []
    @Published var bookedCourses: [Course] = []
    @Published var upcomingBooking: Booking? = nil
    @Published var errorMessage: String? = nil

    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    // Fetch bookings and transform them into courses
    func fetchBookedCourses(userId: String) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("DEBUG: No token found. Cannot fetch bookings.")
            return
        }

        print("DEBUG: Fetching booked courses for userId: \(userId) with token: \(token)")

        APIManager.shared.fetch(endpoint: "/bookings/user/\(userId)") { (result: Result<[Booking], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookings):
                    print("DEBUG: Bookings fetched successfully: \(bookings)")
                    self.bookings = bookings
                    self.bookedCourses = bookings.map { $0.course } // Extract all courses
                    self.updateUpcomingBooking()
                case .failure(let error):
                    self.errorMessage = "Failed to fetch bookings: \(error.localizedDescription)"
                    print("DEBUG: Error fetching bookings: \(error.localizedDescription)")
                }
            }
        }
    }

    // Create a new booking
    func createBooking(userId: String, courseId: String) {
        let body = ["userId": userId, "courseId": courseId]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Failed to serialize booking data.")
            return
        }

        print("Creating booking for userId: \(userId) and courseId: \(courseId)...")
        APIManager.shared.create(endpoint: "/bookings", body: jsonData) { (result: Result<Booking, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let booking):
                    print("Booking created successfully: \(booking)")
                    self.bookings.append(booking)
                    self.bookedCourses.append(booking.course) // Append the full course
                    self.updateUpcomingBooking()
                case .failure(let error):
                    self.errorMessage = "Failed to create booking: \(error.localizedDescription)"
                    print("Error creating booking: \(error.localizedDescription)")
                }
            }
        }
    }

    // Cancel a booking
    func cancelBooking(bookingId: String) {
        print("Canceling booking with id: \(bookingId)...")
        APIManager.shared.delete(endpoint: "/bookings/\(bookingId)") { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Booking canceled successfully.")
                    if let index = self.bookings.firstIndex(where: { $0.id == bookingId }) {
                        self.bookedCourses.removeAll { $0.id == self.bookings[index].course.id } // Remove associated course
                        self.bookings.remove(at: index) 
                    }
                    self.updateUpcomingBooking()
                case .failure(let error):
                    self.errorMessage = "Failed to cancel booking: \(error.localizedDescription)"
                    print("Error canceling booking: \(error.localizedDescription)")
                }
            }
        }
    }

    private func updateUpcomingBooking() {
        let currentDate = Date()

        self.upcomingBooking = bookings
            .compactMap { booking -> Booking? in
                guard let date = dateFormatter.date(from: booking.course.date) else {
                    print("DEBUG: Invalid date format for course: \(booking.course)")
                    return nil
                }
                return date > currentDate ? booking : nil
            }
            .sorted {
                guard let date1 = dateFormatter.date(from: $0.course.date),
                      let date2 = dateFormatter.date(from: $1.course.date) else {
                    return false
                }
                return date1 < date2
            }
            .first

        print("DEBUG: Upcoming booking updated: \(String(describing: self.upcomingBooking))")
    }
}

