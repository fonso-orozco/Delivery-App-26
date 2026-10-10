//
//  EnterDataView.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/9/26.
//

import SwiftUI
import MapKit

struct EnterDataView: View {
    

    
    // location variable for picker
    @State private var selectedLocation: Locations = .crestHill
    // vehicle variabl efor picker
    @State private var selectedVehicle: Vehicles = .truck
    
    // variable to bring up SearchView
    @State private var isSearchSheetPresented: Bool = false
    // environment varibale to dismiss view
    @Environment(\.dismiss) var dismiss
    
    // binding variables passed in from MapView
    @Binding var searchResultTitle: String
    @Binding var isDataEntrySheetPresented: Bool
    @Binding var routeService: LocationRouteService

    
    var body: some View {
        VStack {
        // button displays search results. Brings up SearchView when tapped to enter new address
            Button {
                isSearchSheetPresented = true
            } label: {
                HStack {
                    Image(systemName: "truck.box")
                    Text("\(searchResultTitle)")
                }
                
            }
            .buttonStyle(.bordered)
            .padding()
        
            // starting location segmented picker
            VStack(alignment: .leading) {
                
                Text("Starting Location")
                    .font(.subheadline)
                    .padding(.leading, 20)
                Picker("Starting Location", selection: $selectedLocation) {
                    ForEach(Locations.allCases) { location in
                        Text(location.locationName)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
            
            // selected vehicle segmented picker
            VStack(alignment: .leading) {
                
                Text("Select Vehicle")
                    .font(.subheadline)
                    .padding(.leading, 20)
                Picker("Select Vehicle", selection: $selectedVehicle) {
                    ForEach(Vehicles.allCases) { vehicle in
                        Text(vehicle.vehicleName)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
            
            HStack {
                // cancel button returns user to MapView
                Button {
                    isDataEntrySheetPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Color.red)
                        .clipShape(.capsule)
                    // Simulates depth to look like it hovers
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 3)
                }
                .padding(.trailing, 20) // Push away from the right edge
                .padding(.bottom, 20)   // Push away from the bottom edge
                
                
                // calculate button - calculates the route - will soon bring up ResultsView with calculations
                Button {
                    Task {
                        
                        // reverse geocode location to provide to route service - future refactor into SearchViewModel
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
                            // call route service
                            routeService.getDirections(from: selectedLocation.locationCoordinate, to: destination)
//                            cameraPosition = .automatic
                        }
                    }
                    
                    isDataEntrySheetPresented = false

                } label: {
                    Image(systemName: "checkmark")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Color.green)
                        .clipShape(.capsule)
                    // Simulates depth to look like it hovers
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 3)
                }
                .padding(.trailing, 20) // Push away from the right edge
                .padding(.bottom, 20)   // Push away from the bottom edge
            }
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 400)
        .background(.background)
        .clipShape(.rect)
        .cornerRadius(20)
        .padding(.leading, 20)
        .padding(.trailing, 20) // Push away from the right edge
        .padding(.bottom, 50)   // Push away from the bottom edge
        .sheet(isPresented: $isSearchSheetPresented) {
            SearchView(searchResultTitle: $searchResultTitle, isDataEntrySheetPresented: $isDataEntrySheetPresented)
        }
    }
}

//#Preview {
//    EnterDataView()
//}
