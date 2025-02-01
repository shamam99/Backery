//
//  TabBarView.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: String

    var body: some View {
        HStack {
            TabBarItem(icon: "logo", title: "Home", selectedTab: $selectedTab)
            TabBarItem(icon: "roller", title: "Courses", selectedTab: $selectedTab)
            TabBarItem(icon: "user", title: "Profile", selectedTab: $selectedTab)
        }
        .padding(.vertical, 10)
        .background(Color(UIColor.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: -2)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    @Binding var selectedTab: String

    var body: some View {
        VStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24) 
                .foregroundColor(selectedTab == title ? Color("Primary") : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(selectedTab == title ? Color("Primary") : .gray)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            selectedTab = title
        }
    }
}
