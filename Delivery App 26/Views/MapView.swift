//
//  MapView.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/5/26.
//
//  MapView displays starting screen - contains map, starting location picker,
//  destination search (under construction) and button which performs the routing
//  and calculations
//

import SwiftUI
import MapKit

struct MapView: View {

    
    // toggle for SearchView sheet
    @State private var isSheetPresented: Bool = false
    
    // route variable
    @State var route: MKRoute?
    
//     starting navigation coordinate
    @State var startingLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
//     ending navigation coordinate
    @State var endingLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    
    // location manager to request user location
    let locationManager = CLLocationManager()
    
    // location variable for picker
    @State private var selectedLocation: Locations = .crestHill
  
    // camera position variable
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    // variable stores search address 
    @State private var searchResultTitle = "None"
    
    // distance variable
    @State var travelDistance = 0.0
    
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
            .sheet(isPresented: $isSheetPresented) {
                SearchView(searchResultTitle: $searchResultTitle)
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
                Text("Starting Location")
                    .font(.title2)
            // picker to choose from locations
            Picker("Starting Location", selection: $selectedLocation) {
                ForEach(Locations.allCases) { location in
                    Text(location.locationName)
                }
            }
            
            Button("Location Search") {
                isSheetPresented = true
            }
            
            VStack {
                Text("The address selected is")
                    .font(.title2)
                Text(searchResultTitle)
                Text("The route distance is ")
                    .font(.title2)
                Text("\(travelDistance / 1609.34) miles")
            }
            
            
                    
            // gets directions from selected location to destination
            Button("Get Directions") {
                getDirections(from: selectedLocation.locationCoordinate, to: .joliet)
                cameraPosition = .region(calculateRegion(for: [startingLocation, endingLocation]))
            }
        }
    }
    
    // function creates route from two locations - future refactor target
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
                // pulls distance data from route
                if let route = directions.routes.first {
                    travelDistance = route.distance
                }
               
            } catch {
                print("No directions found")
            }
            
        }
    }
}




#Preview {
    MapView()
}
