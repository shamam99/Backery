//
//  SearchBarView.swift
//  Backery
//
//  Created by Shamam Alkafri on 26/01/2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)

            TextField("Search", text: $searchText)
                .foregroundColor(.black)
                .disableAutocorrection(true)

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .padding(10)
        .background(Color(.grey))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
