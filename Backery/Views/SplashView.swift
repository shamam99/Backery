//
//  SplashView.swift
//  Backery
//
//  Created by Shamam Alkafri on 25/01/2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            MainTabView()
        } else {
            ZStack {
                Color("bg")
                    .edgesIgnoringSafeArea(.all)
                
                Image("placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
