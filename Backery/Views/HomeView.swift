//
//  HomeView.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var showTabBar: Bool

    var body: some View {
        NavigationView {
            VStack {
                Text("Home Bakery")
                    .font(.headline)
                    .foregroundColor(Color("Black"))
                    .padding(.top)
                    .padding(.bottom, 8)

                Divider()
                    .padding(.vertical, 5)

                SearchBarView(searchText: $homeViewModel.searchText)
                    .padding(.vertical, 5)

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Upcoming")
                            .font(.headline)
                            .foregroundColor(Color("Black"))
                            .padding(.horizontal)

                        if let upcomingBooking = bookingViewModel.upcomingBooking {
                            UpcomingView(booking: upcomingBooking)
                                .padding(.horizontal)
                        } else {
                            VStack {
                                Image("rolling")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 100)
                                    .foregroundColor(Color("Grey"))
                                Text("No upcoming courses")
                                    .foregroundColor(Color("Grey"))
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                        }

                        Text("Popular courses")
                            .font(.headline)
                            .foregroundColor(Color("Black"))
                            .padding(.horizontal)
                            .padding(.top, 13)

                        ForEach(homeViewModel.popularCourses) { course in
                            NavigationLink(
                                destination: CourseDetailsView(
                                    course: course,
                                    authViewModel: authViewModel,
                                    bookingViewModel: bookingViewModel 
                                )
                                .onAppear { showTabBar = false }
                                .onDisappear { showTabBar = true }
                            ) {
                                CourseCardView(course: course)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .onAppear {
                homeViewModel.fetchPopularCourses()
                if authViewModel.isLoggedIn {
                    bookingViewModel.fetchBookedCourses(userId: authViewModel.user?.id ?? "")
                }
            }
            .background(Color("bg"))
            .navigationBarHidden(true)
        }
    }
}


// UpcomingView Component
import SwiftUI

struct UpcomingView: View {
    let booking: Booking

    var body: some View {
        HStack(spacing: 14) {
            // Date Section
            VStack(alignment: .center, spacing: 4) {
                Text(monthName(from: booking.course.date))
                    .font(.title3)
                    .foregroundColor(Color("Brown"))
                Text(dayNumber(from: booking.course.date))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Brown"))
            }
            .frame(width: 60)

            Divider()
                .frame(width: 5, height: 70)
                .background(Color("Primary"))

            // Course Details
            VStack(alignment: .leading, spacing: 6) {
                Text(booking.course.name)
                    .font(.headline)
                    .foregroundColor(Color("Black"))
                
                // Location with Icon
                HStack(spacing: 8) {
                    Image(systemName: "location")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Color("Brown"))
                    Text(booking.course.location)
                        .font(.subheadline)
                        .foregroundColor(Color("Black"))
                }
                
                // Time with Icon
                HStack(spacing: 8) {
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Color("Brown"))
                    Text(formatTime(from: booking.course.date))
                        .font(.subheadline)
                        .foregroundColor(Color("Black"))
                }
            }
            .padding(.leading, 4)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    // Extract month name
        private func monthName(from date: String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            guard let parsedDate = formatter.date(from: date) else { return "" }

            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM"
            return monthFormatter.string(from: parsedDate)
        }

        // Extract day number
        private func dayNumber(from date: String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            guard let parsedDate = formatter.date(from: date) else { return "" }

            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "d"
            return dayFormatter.string(from: parsedDate)
        }

        // Extract and format time
        private func formatTime(from date: String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            guard let parsedDate = formatter.date(from: date) else { return "" }

            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: parsedDate)
        }
    }


struct HomeView_Previews: PreviewProvider {
    @State static var showTabBar: Bool = true

    static var previews: some View {
        HomeView(authViewModel: AuthViewModel(), showTabBar: $showTabBar)
            .environmentObject(HomeViewModel())
    }
}
