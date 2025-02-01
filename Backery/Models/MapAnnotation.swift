//
//  MapAnnotation.swift
//  Backery
//
//  Created by Shamam Alkafri on 27/01/2025.
//

import Foundation
import MapKit

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
