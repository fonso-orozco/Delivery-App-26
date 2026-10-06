//
//  LocationModel.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/5/26.
//
//  Contains the data model for starting location. This model owns data for each data location.
//

import MapKit



// locations struct
enum Locations: String, CaseIterable, Identifiable {
    case crestHill, joliet, orlandPark
    var id: Self { self }
    
    
}

// extension on locations struct returns CLLocationCoordinate2D for corresponding location
extension Locations {
    
    var locationName: String {
        switch self {
        case .crestHill: return "Crest Hill"
        case .joliet: return "Joliet"
        case .orlandPark: return "Orland Park"
        }
        
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        switch self {
        case .crestHill: return .crestHill
        case .joliet: return .joliet
        case .orlandPark: return .orlandPark
        }
    }
}

// extension on CLLoactionCoordinate2d stores static location coordinates
extension CLLocationCoordinate2D {
    static let crestHill = CLLocationCoordinate2D(latitude: 41.5432, longitude: -88.1408)
    static let joliet = CLLocationCoordinate2D(latitude: 41.5353965, longitude: -88.0816650)
    static let orlandPark = CLLocationCoordinate2D(latitude: 41.61387, longitude: -87.79368)
}
