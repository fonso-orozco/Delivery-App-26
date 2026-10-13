//
//  VehicleModel.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/9/26.
//
// This model holds information on selected vehicle, including vehicle type, name and cost multipier

import SwiftUI

// vehicles struct
enum Vehicles: String, CaseIterable, Identifiable {
    case truck, truckAndTrailer, rolloff
    var id: Self { self }
}

// vehicles extension, returns name - will update to return delivery rate multiplier
extension Vehicles {
    
    var vehicleName: String {
        switch self {
        case .truck: return "Truck"
        case .truckAndTrailer: return "Truck and Trailer"
        case .rolloff: return "Roll Off"
        }
        
    }
    
    // cost multiplier
    var vehicleMultiplier: Double {
        switch self {
        case .truck: return 1.0
        case .truckAndTrailer: return 1.5
        case .rolloff: return 2.0
        }
    }

}
