//
//  MainTabView.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//


import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: String = "Home"
    @State private var showTabBar: Bool = true
    @StateObject private var bookingViewModel = BookingViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 0) {
            if selectedTab == "Home" {
                HomeView(
                    authViewModel: authViewModel,
                    showTabBar: $showTabBar
                )
                .environmentObject(bookingViewModel) 
            } else if selectedTab == "Courses" {
                CoursesView(
                    bookingViewModel: bookingViewModel,
                    authViewModel: authViewModel,
                    selectedTab: $selectedTab,
                    showTabBar: $showTabBar
                )
            } else if selectedTab == "Profile" {
                ProfileView(
                    profileViewModel: profileViewModel,
                    showTabBar: $showTabBar
                )
                .environmentObject(bookingViewModel) // Pass BookingViewModel as EnvironmentObject
            }

            if showTabBar {
                TabBarView(selectedTab: $selectedTab)
            }
        }
        .onAppear {
            if authViewModel.isLoggedIn {
                bookingViewModel.fetchBookedCourses(userId: authViewModel.user?.id ?? "")
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}




struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
