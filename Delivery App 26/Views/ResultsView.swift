//
//  ResultsView.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/11/26.
//

import SwiftUI

struct ResultsView: View {
    
    
    // environment varibale to dismiss view
    @Environment(\.dismiss) var dismiss
    @Binding var isResultsSheetPresented: Bool
    @Binding var showPolyLine: Bool
    @Binding var routeService: LocationRouteService
    
    var body: some View {
        
        VStack {
            Text("The delivery distance is \(routeService.travelDistance / 1609) miles")
                .clipShape(.capsule)
            Text("The estimated travel time is \(routeService.expectedTravelTime / 3600) hours")
                .clipShape(.capsule)
            Text("The cost for this delivery is \(routeService.totalCost) dollars")
                .clipShape(.capsule)
            
            HStack {
                // done button returns user to MapView
                Button {
                    withAnimation {
                        isResultsSheetPresented = false
                        showPolyLine = false
                    }

                } label: {
                    HStack {
                        Text("Done")
                        Image(systemName: "xmark")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)
                            .padding(20)
                            .background(Color.red)
                            .clipShape(.capsule)
                        // Simulates depth to look like it hovers
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 3)
                    }
//                    .padding(.trailing, 20) // Push away from the right edge
//                    .padding(.bottom, 20)   // Push away from the bottom edge
                    
                }
            }
        }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(.background)
            .clipShape(.rect)
            .cornerRadius(20)
    }
    
}
