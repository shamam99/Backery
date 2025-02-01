//
//  MapView.swift
//  Backery
//
//  Created by Shamam Alkafri on 27/01/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    let location: String

    var body: some View {
        let coordinates = getCoordinates(for: location)

        let annotation = MapAnnotation(coordinate: coordinates)

        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )), annotationItems: [annotation]) { item in
            MapPin(coordinate: item.coordinate)
        }
        .frame(height: 200)
        .cornerRadius(10)
    }

    private func getCoordinates(for location: String) -> CLLocationCoordinate2D {
        switch location.lowercased() {
        case "riyadh":
            return CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)
        case "jeddah":
            return CLLocationCoordinate2D(latitude: 21.4858, longitude: 39.1925)
        case "dammam":
            return CLLocationCoordinate2D(latitude: 26.3927, longitude: 49.9777)
        default:
            return CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753) // Default to Riyadh
        }
    }
}
