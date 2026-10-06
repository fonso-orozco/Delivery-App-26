//
//  MapViewModel.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/5/26.
//
//  MapViewModel contains supporting functions for MapView. Functions calculate the display window for the map
//  and the user's current location
//

import SwiftUI
import MapKit


@Observable
final class MapViewModel {
    
    
    
    
    
    
    
    // function to calculate MKCoordinateRegion from coordinates
    func calculateRegion(for coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coords.isEmpty else {
            return MKCoordinateRegion()
        }
        
        var minLat = coords[0].latitude
        var maxLat = coords[0].latitude
        var minLon = coords[0].longitude
        var maxLon = coords[0].longitude
        
        for coord in coords {
            minLat = min(minLat, coord.latitude)
            maxLat = max(maxLat, coord.latitude)
            minLon = min(minLon, coord.longitude)
            maxLon = max(maxLon, coord.longitude)
        }
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.3, // Add 30% padding
            longitudeDelta: (maxLon - minLon) * 1.3
        )
        
        return MKCoordinateRegion(center: center, span: span)
    }

    // get user location coordinate
    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        

        do {
            let update = try await updates.first { $0.location?.coordinate != nil}
            return update?.location?.coordinate
        } catch {
            print("Can not get user location")
            return nil
        }
    }

    
}


