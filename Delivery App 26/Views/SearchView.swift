//
//  SearchView.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/6/26.
//
// SearchView contains search bar and presents search results in list for user
//

import SwiftUI

struct SearchView: View {
    // variable stores location search instance
    @State var locationSearch = LocationSearchService()
    
    // binding variable to pass data back to MapView
    @Binding var searchResultTitle: String
    
    // bindinv variable to dismiss view
    @Binding var isDataEntrySheetPresented: Bool
    
    
    // variable to dismiss sheet when result is selected from list
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {

        VStack {
            // Search textfield
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Enter address", text: $locationSearch.query)
                    .autocorrectionDisabled()
                }
                .modifier(TextFieldGrayBackgroundColor())

                Spacer()
            
            if locationSearch.results.isEmpty {
                ContentUnavailableView("Search for a jobsite", systemImage: "magnifyingglass")
            } else {
                List(locationSearch.results) { result in
                    VStack(alignment: .leading) {
                        Text(result.title)
                        Text(result.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    // sends selected address to MapView when list item is tapped
                    .onTapGesture {
                        searchResultTitle = " \(result.title) \n \(result.subtitle)"
                        isDataEntrySheetPresented = true
                        dismiss()
                        }
                    }
                }
            }
                // styling
                .padding()
                .presentationDetents([.large])
                .presentationBackground(.regularMaterial)
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
}

//// search field styling
struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}

//#Preview {
//    @Previewable @State var searchResultTitle: String = "Blank"
//    SearchView(searchResultTitle: $searchResultTitle, isDataEntrySheetPresented: $isDataEntrySheetPresented)
//}
