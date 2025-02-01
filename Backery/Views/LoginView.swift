//
//  LoginView.swift
//  Backery
//
//  Created by Shamam Alkafri on 28/01/2025.
//

import SwiftUI

struct LoginView: View {
    @Binding var isPresented: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            // Background color for the entire sheet
            Color("bg")
                .edgesIgnoringSafeArea(.all)

            // Sheet Content
            VStack(spacing: 20) {
                // Header with "Sign in" and close button
                HStack {
                    Spacer()
                    Text("Sign in")
                        .font(.headline)
                        .foregroundColor(Color("Black"))
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("Black"))
                            .padding(.trailing)
                    }
                }
                .padding(.top)

                Spacer(minLength: 10)

                // Email field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(Color("Black"))
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .frame(maxWidth: 300)

                // Password field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(Color("Black"))
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    )
                }
                .frame(maxWidth: 300)

                // Sign in button
                Button(action: {
                    authViewModel.login(email: email, password: password) { success, errorMessage in
                        if success {
                            isPresented = false
                        } else {
                            print("Login failed: \(errorMessage ?? "Unknown error")")
                        }
                    }
                }) {
                    Text("Sign in")
                        .frame(maxWidth: 250)
                        .padding()
                        .background(Color("Primary"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding(.top)
            .background(Color("bg"))
            .cornerRadius(20)

        }
    }
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            isPresented: .constant(true),
            authViewModel: AuthViewModel()
        )
        .background(Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all))
    }
}
