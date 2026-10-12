//
//  MapViewModel.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/5/26.
//
//  MapViewModel contains supporting functions for MapView. Functions calculate the display window for the map
//  and the user's current location
//

import MapKit
    
// function creates route from coordinates and gets route distance
@Observable
class LocationRouteService: NSObject {
    
    // route variable
        var route: MKRoute?
    
    //     starting navigation coordinate
        var startingLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
    //     ending navigation coordinate
        var endingLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    // distance variable
        var travelDistance = 0.0
    
    // expected travel time
        var expectedTravelTime = 0.0
    
    var totalCost = 0.0
    
    // function creates route from two locations and vehicle type
    func getDirections(from start: CLLocationCoordinate2D, to destination: MKMapItem, vehicleMultiplier: Double) {
        
    // set starting and ending locations
        startingLocation = start
        endingLocation = destination.location.coordinate
        
        // creates route asynchronusly
        Task {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: start))
            request.destination = destination
            
            // directions for vehicle
            request.transportType = .automobile
            do {
                let directions = try await MKDirections(request: request).calculate()
                route = directions.routes.first
                // pulls distance data from route
                if let route = directions.routes.first {
                    travelDistance = route.distance
                    expectedTravelTime = route.expectedTravelTime
                    calculateCost(travelDistance: travelDistance, vehicleMultiplier: vehicleMultiplier)
                }
               
            } catch {
                print("No directions found")
            }
            
        }
    }
    
    // calculates delivery cost based on base rate, vehicle type and distance
    func calculateCost(travelDistance: Double, vehicleMultiplier: Double) {
    
        let travelInMiles = travelDistance / 1609
        let baseDelivery = 200.0
        let costPerMile = 10.0
    
        print(travelInMiles)
    
        if travelInMiles < 5.0 {
        totalCost = baseDelivery * vehicleMultiplier
    } else {
        totalCost = baseDelivery + (costPerMile * travelInMiles) * vehicleMultiplier
    }


    }
    
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

