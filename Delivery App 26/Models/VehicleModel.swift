//
//  VehicleModel.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/9/26.
//

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

}
