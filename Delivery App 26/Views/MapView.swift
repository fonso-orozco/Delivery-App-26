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

    @State private var routeService = LocationRouteService()
    
    // toggle for SearchView sheet
    @State private var isSearchSheetPresented: Bool = false
    @State private var isDataEntrySheetPresented: Bool = false
       
    // location manager to request user location
    let locationManager = CLLocationManager()
    
//    // location variable for picker
    @State private var selectedLocation: Locations = .crestHill
    
    @State private var destination: MKMapItem?
  
    // camera position variable
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    // variable stores search address 
    @State private var searchResultTitle = "None"
    

    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
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
            .sheet(isPresented: $isSearchSheetPresented) {
                SearchView(searchResultTitle: $searchResultTitle, isDataEntrySheetPresented: $isDataEntrySheetPresented)
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
            
            
            if isDataEntrySheetPresented {
                EnterDataView(searchResultTitle: $searchResultTitle, isDataEntrySheetPresented: $isDataEntrySheetPresented, routeService: $routeService)
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
            }
           
            if isDataEntrySheetPresented == false {
                Button {
                    isSearchSheetPresented = true
                    cameraPosition = .automatic

                    
                         } label: {
                             Image(systemName: "plus")
                                 .font(.title2.weight(.bold))
                                 .foregroundColor(.white)
                                 .padding(20)
                                 .background(Color.blue)
                                 .clipShape(Circle())
                                 // Simulates depth to look like it hovers
                                 .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 3)
                         }
                         .padding(.trailing, 20) // Push away from the right edge
                         .padding(.bottom, 20)   // Push away from the bottom edge
                         
                     }
            }
        }
        
    }

        
        
       
      
    




#Preview {
    MapView()
}
