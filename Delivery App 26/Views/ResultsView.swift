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
            // delivery distance
            HStack {
                Text("The delivery distance is")
//                    .padding(.trailing, 40)
                Spacer()
                Text("\(routeService.travelDistance / 1609) n mi")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray5).opacity(0.7)))
            .padding(.leading, 15)
            .padding(.trailing, 15)
            
            // travel time
            HStack {
                Text("The estimated travel time is")
                Spacer()
                Text("\(routeService.expectedTravelTime / 3600) h")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray5).opacity(0.7)))
            .padding(.leading, 15)
            .padding(.trailing, 15)

            // cost info
            
            HStack {
                Text("The cost for this delivery is ")
                Spacer()
                Text("$\(routeService.totalCost)")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray5).opacity(0.7)))
            .padding(.leading, 15)
            .padding(.trailing, 15)
                        
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
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)
                            .padding(20)
                            .background(Color.red)
                            .clipShape(.capsule)
                        // Simulates depth to look like it hovers
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 3)
                    }
                    
                }
            }
        }
    }
    
}
