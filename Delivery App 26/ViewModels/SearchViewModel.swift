//
//  SearchViewModel.swift
//  Delivery App 26
//
//  Created by Fonso Orozco on 10/6/26.
//
//  Contains supporting functions for SearchView, including the search function and the auto complete functions
//

import MapKit
import Foundation



// location service structure - Observable
@Observable
class LocationSearchService: NSObject {
    
    // gets query results and calls search function whenever property changes
    var query: String = "" {
        didSet {
            handleSearchFragment(query)
        }
    }
    
    // array of location results for possible search results
    var results: [LocationResult] = []
    // enum representing current state of search
    var status: SearchStatus = .idle
    // initiate instance of search completer
    var completer: MKLocalSearchCompleter
    
    // locationSearchService initializer
    init(filter: MKPointOfInterestFilter = .excludingAll,
         region: MKCoordinateRegion = MKCoordinateRegion(.world),
         types: MKLocalSearchCompleter.ResultType = [.pointOfInterest, .query, .address]) {
        
        completer = MKLocalSearchCompleter()
        
        super.init()
        
        completer.delegate = self
        completer.pointOfInterestFilter = filter
        completer.region = region
        completer.resultTypes = types
    }
    
    // function called whenever query changes
    private func handleSearchFragment(_ fragment: String) {
        // updates status to searching
        self.status = .searching
        
        // if fragment empty, set idle to empty and return empty search results
        if !fragment.isEmpty {
            self.completer.queryFragment = fragment
        } else {
            self.status = .idle
            self.results = []
        }
    }
}

// initialize MKLocalSearchCompleterDelegate

extension LocationSearchService: MKLocalSearchCompleterDelegate {
    
    // updates LocationSearchService when new results are available
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results.map({result in
            LocationResult(title: result.title, subtitle: result.subtitle)
            })
        self.status = .result
    }
    
    // error handling
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}

// search result data structure
struct LocationResult: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
}

// search status struct
enum SearchStatus: Equatable {
    case idle
    case searching
    case error(String)
    case result
}

