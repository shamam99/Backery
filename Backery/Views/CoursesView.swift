//
//  CoursesView.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import SwiftUI

struct CoursesView: View {
    @StateObject private var courseViewModel = CourseViewModel()
    @ObservedObject var bookingViewModel: BookingViewModel
    @ObservedObject var authViewModel: AuthViewModel // Add authViewModel
    @Binding var selectedTab: String
    @Binding var showTabBar: Bool

    var body: some View {
        NavigationView {
            VStack {
                // Page Title
                Text("Courses")
                    .font(Font.headline)
                    .foregroundColor(Color("Black"))
                    .padding(.top)
                    .padding(.bottom, 8)

                Divider()
                    .padding(.vertical, 10)

                // Search Bar
                SearchBarView(searchText: $courseViewModel.searchText)
                    .onChange(of: courseViewModel.searchText) { _ in
                        courseViewModel.filterCourses()
                    }

                // Courses List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if courseViewModel.filteredCourses.isEmpty {
                            VStack {
                                Image("rolling")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 100)
                                    .foregroundColor(Color("Grey"))
                                Text("No courses available")
                                    .foregroundColor(Color("Grey"))
                                    .font(Font.subheadline)
                            }
                            .padding(.top, 50)
                        } else {
                            ForEach(courseViewModel.filteredCourses) { course in
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
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            .onAppear {
                courseViewModel.fetchCourses()
            }
            .background(Color("bg"))
            .navigationBarHidden(true)
        }
    }
}



struct CoursesView_Previews: PreviewProvider {
    @State static var showTabBar: Bool = true

    static var previews: some View {
        CoursesView(
            bookingViewModel: BookingViewModel(),
            authViewModel: AuthViewModel(), // Pass authViewModel first
            selectedTab: .constant("Courses"),
            showTabBar: $showTabBar
        )
    }
}
