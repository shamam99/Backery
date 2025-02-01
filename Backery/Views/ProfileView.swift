//
//  ProfileView.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @Binding var showTabBar: Bool
    @State private var isEditing: Bool = false
    @State private var editedName: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            // Page Title
            Text("Profile")
                .font(.headline)
                .padding(.top)
            
            Divider()
                .padding(.bottom, 8)

            // User Info Card
            HStack {
                // User Avatar
                AsyncImage(url: URL(string: profileViewModel.user?.avatar ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color("Brown"), lineWidth: 2)
                        )
                } placeholder: {
                    Image("userimage") // Replace with your placeholder image name
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color("Brown"), lineWidth: 2)
                        )
                }

                // Editable Name Field
                if isEditing {
                    TextField("Enter name", text: $editedName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 35)
                } else {
                    Text(profileViewModel.user?.name ?? "Name")
                        .font(.headline)
                        .foregroundColor(Color("Black"))
                }

                Spacer()

                // Edit/Done Button
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        profileViewModel.user?.name = editedName
                        profileViewModel.updateUserName(newName: editedName) { success, message in
                            alertMessage = message
                            showAlert = true
                        }
                    } else {
                        editedName = profileViewModel.user?.name ?? ""
                    }
                    isEditing.toggle()
                }
                .foregroundColor(Color("Primary"))
                .padding(.horizontal)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)

            Divider()
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, 8)
            
            Spacer()

            // Booked Courses Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Booked Courses")
                    .font(.headline)
                    .padding(.horizontal)

                if bookingViewModel.bookedCourses.isEmpty {
                    Text("No courses booked.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(bookingViewModel.bookedCourses, id: \.id) { course in
                                CourseCardView(course: course)
                                    .padding(.horizontal)
                                    .contextMenu {
                                        Button("Cancel Booking", role: .destructive) {
                                            bookingViewModel.cancelBooking(bookingId: course.id)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .padding(.top, 5)
        }
        .background(Color("bg"))
        .onAppear {
            profileViewModel.fetchUser()
            if let userId = profileViewModel.user?.id {
                bookingViewModel.fetchBookedCourses(userId: userId)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// ProfileView Preview
struct ProfileView_Previews: PreviewProvider {
    @State static var showTabBar: Bool = true
    static var previews: some View {
        ProfileView(profileViewModel: ProfileViewModel(), showTabBar: $showTabBar)
    }
}
