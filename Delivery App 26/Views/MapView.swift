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

    var routeService = LocationRouteService()
    
    // toggle for SearchView sheet
    @State private var isSheetPresented: Bool = false
       
    // location manager to request user location
    let locationManager = CLLocationManager()
    
    // location variable for picker
    @State private var selectedLocation: Locations = .crestHill
    
    @State private var destination: MKMapItem?
  
    // camera position variable
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    // variable stores search address 
    @State private var searchResultTitle = "None"
    

    var body: some View {
        Map(position: $cameraPosition) {

                UserAnnotation()
                
            if let route = routeService.route {
              // draws navigation line to map and places markers for starting and ending                 locations
                MapPolyline(route)
                    .stroke(Color.blue, lineWidth: 4)
                    
                    // Starting location marker
                Marker("Start", systemImage: "truck.box", coordinate: routeService.startingLocation)
                Marker("Destination", systemImage: "scope", coordinate: routeService.endingLocation)
                
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
                Text("\(routeService.travelDistance / 1609.34) miles")
            }
            
            
                    
            // gets directions from selected location to destination
            Button("Get Directions") {
              
                Task {
                    
                    var addressMapItems = [MKMapItem]()
                        if let request = MKGeocodingRequest(addressString: searchResultTitle) {
                            do {
                                let mapitems = try await request.mapItems
                                if let mapitem = mapitems.first {
                                    addressMapItems.append(mapitem)
                                }
                            } catch let error {
                                print("error: \(error)")
                            }
                        }
                    if let destination = addressMapItems.first {
                        routeService.getDirections(from: selectedLocation.locationCoordinate, to: destination)
                        cameraPosition = .automatic
                    }
                }
            }
        }
    }
    

}




#Preview {
    MapView()
}
