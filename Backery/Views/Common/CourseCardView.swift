//
//  CourseCardView.swift
//  Backery
//
//  Created by Shamam Alkafri on 26/01/2025.
//

import SwiftUI

struct CourseCardView: View {
    let course: Course

    var body: some View {
        HStack(spacing: 10) {
            // Image
            if let imagePath = course.image, let image = UIImage(contentsOfFile: imagePath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            // Course Details
            VStack(alignment: .leading, spacing: 6) {
                Text(course.name)
                    .font(.headline)
                    .foregroundColor(Color("Black"))
                    .lineLimit(1)

                Text(course.level)
                    .font(.system(size: 12, design: .rounded))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(getLevelColor(level: course.level))
                    .foregroundColor(.white)
                    .cornerRadius(6)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: "hourglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundColor(Color("Brown"))
                        Text("2h")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Color("Black"))
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14) 
                            .foregroundColor(Color("Brown"))
                        Text("\(formatDate(course.date)) - \(formatTime(course.time))")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Color("Black"))
                    }
                }
            }
            Spacer()
        }
        .padding(8)
        .background(Color("White"))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
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
