//
//  CourseDetailsView.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import SwiftUI

struct CourseDetailsView: View {
    let course: Course
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var bookingViewModel: BookingViewModel
    @State private var isBooked: Bool = false
    @State private var showCustomAlert: Bool = false
    @State private var showAlert: Bool = false
    @State private var showLoginView: Bool = false
    @State private var alertMessage: String = ""
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        ZStack {
            // Main content of the page
            VStack(alignment: .leading, spacing: 18) {
                // Custom Back Button and Title
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 18)
                            .foregroundColor(Color("Primary"))
                    }
                    Spacer()
                    Text(course.name)
                        .font(.headline)
                        .foregroundColor(Color("Black"))
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)

                // Course Image
                if let imageUrl = URL(string: course.image ?? "") {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(height: 200)
                    } placeholder: {
                        Image("placeholder")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color("White"))
                            .frame(width: 200, height: 200)
                    }
                }

                // About Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("About the course:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    ScrollView {
                        Text(course.description)
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(Color("Black"))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal)

                Divider()
                    .padding(.horizontal)

                // Metadata Section
                HStack(alignment: .top, spacing: 20) {
                    // Left VStack
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 4) {
                            Text("Chef:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Black"))
                            Text(course.chef)
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Color("Black"))
                        }
                        
                        HStack(spacing: 4) {
                            Text("Level:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Black"))
                            Text(course.level)
                                .font(.system(size: 12, design: .rounded))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(getLevelColor(level: course.level))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                        
                        HStack(spacing: 4) {
                            Text("Date & time:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Black"))
                            Text("\(formatDate(course.date)) - \(formatTime(course.time))")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Color("Black"))
                        }
                    }
                    
                    Spacer()
                    
                    // Right VStack
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 4) {
                            Text("Duration:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Black"))
                            Text("2h")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Color("Black"))
                        }
                        .padding(.top, 25)
                        
                        HStack(spacing: 4) {
                            Text("Location:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Black"))
                            Text(course.location)
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Color("Black"))
                        }
                    }
                }
                .padding(.horizontal)

                // Map View
                MapView(location: course.location)
                    .frame(height: 150)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding(.horizontal)

                // Book or Cancel Button
                Button(action: {
                    if isBooked {
                        showCustomAlert = true
                    } else {
                        bookCourse()
                    }
                }) {
                    Text(isBooked ? "Cancel Booking" : "Book a Space")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isBooked ? Color("bg") : Color("Primary"))
                        .foregroundColor(isBooked ? Color.red : Color("bg"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.top, 8)
            .navigationBarBackButtonHidden(true)
            .background(Color("bg"))

            // Custom Alert for Cancel Booking
            if showCustomAlert {
                ZStack {
                    Color.black.opacity(0.36)
                        .edgesIgnoringSafeArea(.all)
                    
                    // Alert content
                    VStack(spacing: 12) {
                        Text("Cancel booking?")
                            .font(.headline)
                            .foregroundColor(Color("Black"))
                        
                        Text("Do you want to cancel your booking")
                            .font(.subheadline)
                            .foregroundColor(Color("Black").opacity(0.8))
                        
                        Divider()
                        
                        HStack(spacing: 0) {
                            Button("No") {
                                showCustomAlert = false
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .foregroundColor(Color("Primary"))
                            .padding(.vertical, 4)
                            
                            Divider()
                            
                            Button("Yes") {
                                cancelBooking()
                                showCustomAlert = false
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .foregroundColor(Color("Primary"))
                            .padding(.vertical, 4)
                        }
                        .frame(maxHeight: 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color("bg").opacity(0.95))
                    .cornerRadius(15)
                    .frame(maxWidth: 320)
                    .frame(maxHeight: 200)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showLoginView) {
            ZStack {
                Color.black.opacity(0.36)
                    .edgesIgnoringSafeArea(.all)

                LoginView(isPresented: $showLoginView, authViewModel: authViewModel)
            }
        }
        .onAppear {
            checkBookingStatus()
        }
    }
    // MARK: - Helper Methods
    private func bookCourse() {
        guard authViewModel.isLoggedIn else {
            showLoginView = true
            return
        }
        bookingViewModel.createBooking(userId: authViewModel.user?.id ?? "", courseId: course.id)
        isBooked = true
        alertMessage = "\(course.name) booked successfully."
        showAlert = true
    }

    private func cancelBooking() {
        guard let booking = bookingViewModel.bookings.first(where: { $0.course.id == course.id }) else { return }
        bookingViewModel.cancelBooking(bookingId: booking.id)
        isBooked = false
        alertMessage = "Booking canceled for \(course.name)."
        showAlert = true
    }

    private func checkBookingStatus() {
        isBooked = bookingViewModel.bookedCourses.contains(where: { $0.id == course.id })
    }

    private func getLevelColor(level: String) -> Color {
        switch level {
        case "Beginner": return Color("Cream")
        case "Intermediate": return Color("Brown")
        case "Advanced": return Color("Primary")
        default: return Color("Grey")
        }
    }

    private func formatDate(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMM"
        if let parsedDate = formatter.date(from: date) {
            return outputFormatter.string(from: parsedDate)
        }
        return date
    }

    private func formatTime(_ time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        if let parsedTime = formatter.date(from: time) {
            return outputFormatter.string(from: parsedTime)
        }
        return time
    }
}
