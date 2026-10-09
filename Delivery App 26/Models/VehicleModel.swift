//
//  VehicleModel.swift
//  Delivery App 26
//
//  Created by Ildefonso Orozco on 10/9/26.
//

import SwiftUI

// vehicles struct
enum Vehicles: String, CaseIterable, Identifiable {
    case truck, truckAndTrailer, rolloff
    var id: Self { self }
}

extension Vehicles {
    
    var vehicleName: String {
        switch self {
        case .truck: return "Truck"
        case .truckAndTrailer: return "Truck and Trailer"
        case .rolloff: return "Roll Off"
        }
        
    }

}
