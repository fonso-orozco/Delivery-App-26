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
    // variable stores search results
    @State private var search: String = ""
    
    var body: some View {
        VStack {
            // Search textfield
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a jobsite", text: $search)
                    .autocorrectionDisabled()
                }
                .modifier(TextFieldGrayBackgroundColor())

                Spacer()
            }
                .padding()
                // Won't allow user to swipe down until search is completed - currently disabled
//                .interactiveDismissDisabled()
                // styling
                .presentationDetents([.large])
                .presentationBackground(.regularMaterial)
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
}

// search field styling
struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}

#Preview {
    SearchView()
}
