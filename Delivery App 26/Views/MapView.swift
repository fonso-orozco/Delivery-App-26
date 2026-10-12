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
    
    // variables to display various views
    @State private var isSearchSheetPresented: Bool = false
    @State private var isDataEntrySheetPresented: Bool = false
    @State private var isResultsSheetPresented: Bool = false
    @State private var showPolyLine: Bool = false
    
    // variable for vehicle type picker
    @State private var selectedVehicle: Vehicles = .truckAndTrailer
       
    // location manager to request user location
    let locationManager = CLLocationManager()
    
    // location variable for picker
    @State private var selectedLocation: Locations = .crestHill
    
    // destination variable
    @State private var destination: MKMapItem?
  
    // camera position variable
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    // variable stores search address 
    @State private var searchResultTitle = "None"

    var body: some View {
        
        VStack {
            
            ZStack(alignment: .bottomTrailing) {
                
                Map(position: $cameraPosition) {
                    
                    UserAnnotation()
                // draws navigation line to map and places markers for starting and ending                 locations
                    if showPolyLine {
                        if let route = routeService.route {
                          
                            // route polyine
                            MapPolyline(route)
                                .stroke(Color.blue, lineWidth: 4)
                            
                            // Starting location marker
                            Marker("Start", systemImage: "truck.box", coordinate: routeService.startingLocation)
                            Marker("Destination", systemImage: "scope", coordinate: routeService.endingLocation)
                        }
                    }
                   
                    
                }
                // search sheet sheet view
                .sheet(isPresented: $isSearchSheetPresented) {
                    SearchView(searchResultTitle: $searchResultTitle, isDataEntrySheetPresented: $isDataEntrySheetPresented)
                }
               
                // on app open asks for user location
                .onAppear {
                    locationManager.requestWhenInUseAuthorization()
                }
                // map controls
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapPitchToggle()
                    MapScaleView()
                }
                
                // if button is tapped show EnterDataView
                if isDataEntrySheetPresented {
                    EnterDataView(selectedVehicle: $selectedVehicle, searchResultTitle: $searchResultTitle, isDataEntrySheetPresented: $isDataEntrySheetPresented, routeService: $routeService, isResultsSheetPresented: $isResultsSheetPresented, showPolyLine: $showPolyLine)
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .transition(AnyTransition.move(edge: .bottom))
                }
                
       
               // otherwise show plus button which presents EnterDataView
                if isDataEntrySheetPresented == false
                    && isResultsSheetPresented == false {
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
        
        // if calculate button is pressed, results are shown
        if isResultsSheetPresented {
                
            ResultsView(isResultsSheetPresented: $isResultsSheetPresented, showPolyLine: $showPolyLine, routeService: $routeService)
                .transition(AnyTransition.move(edge: .bottom))
                .frame(maxWidth: .infinity)
                .frame(height: 300)

        }
        
            }
    }

#Preview {
    MapView()
}
