//
//  MapView.swift
//  Delivery App 26
//
//  Created by Ildefonso Orozco on 10/5/26.
//

import SwiftUI
import MapKit

struct MapView: View {

    var mapViewModel = MapViewModel()
    
    // route variable
    @State var route: MKRoute?
    
//     starting navigation coordinate
    @State private var startingLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
//     ending navigation coordinate
    @State private var endingLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    
    // location manager to request user location
    let locationManager = CLLocationManager()
    
    // location variable for picker
    @State private var selectedLocation: Locations = .crestHill
  
    // camera position variable
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        Map(position: $cameraPosition) {

                UserAnnotation()
                
            if let route {
              // draws navigation line to map and places markers for starting and ending                 locations
                MapPolyline(route)
                    .stroke(Color.blue, lineWidth: 4)
                    
                    // Starting location marker
                Marker("Start", systemImage: "truck.box", coordinate: startingLocation)

                    // Ending location Marker
                Marker("Destination", systemImage: "scope", coordinate: endingLocation)
            }
                
            }
            // on map open
            .onAppear {
                // asks for user location
                locationManager.requestWhenInUseAuthorization()
                }
            // map controls
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            // map style
            .mapStyle(.hybrid)
        
        VStack {
            HStack {
                Text("Starting Location")
                    .font(.title2)
            }
            // picker to choose from locations
            Picker("Starting Location", selection: $selectedLocation) {
                ForEach(Locations.allCases) { location in
                    Text(location.locationName)
                }

            }
            
            // gets directions from selected location to destination
            Button("Get Directions") {
                getDirections(from: selectedLocation.locationCoordinate, to: .orlandPark)
                cameraPosition = .region(mapViewModel.calculateRegion(for: [startingLocation, endingLocation]))
            }
        }
    }
    
    // function creates route from two locations
    func getDirections(from start: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        // set starting and ending locations
        startingLocation = start
        endingLocation = destination
        
        Task {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: start))
            request.destination = MKMapItem(placemark: .init(coordinate: destination))
            request.transportType = .automobile
            
            do {
                let directions = try await MKDirections(request: request).calculate()
                route = directions.routes.first
            } catch {
                print("No directions found")
            }
            
        }
    }
}


#Preview {
    MapView()
}
