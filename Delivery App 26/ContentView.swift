import SwiftUI
import MapKit

struct ContentView: View {
    
    // location manager to request user location
    let locationManager = CLLocationManager()
    
    // location variable for picker
    @State private var selectedLocation: Locations = .crestHill
    
    // starting navigation coordinate
    @State private var startingLocation = CLLocationCoordinate2D.crestHill
    
    // ending navigation coordinate
    @State private var endingLocation = CLLocationCoordinate2D.joliet
    
    // route variable
    @State private var route: MKRoute?
    
    // camera position variable
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
            // map centered on camera position
            Map(position: $cameraPosition) {

                UserAnnotation()
                
                // draws navigation line to map and places markers for starting and ending locations
                if let route {
                    MapPolyline(route)
                        .stroke(Color.blue, lineWidth: 4)
                    
                    // Starting location marker
                    Marker("Start", systemImage: "truck.box", coordinate: startingLocation)

                    // Ending location Marker
                    Marker("Destination", systemImage: "scope", coordinate: endingLocation)
                }
                
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
            HStack {
                Text("Starting Location")
                    .font(.title2)
            }
            // picker to choose from locations
            Picker("Starting Location", selection: $selectedLocation) {
                ForEach(Locations.allCases) { location in
                    Text(location.locationName)
                }

            }
            
            // gets directions from selected location to destination
            Button("Get Directions") {
                getDirections(from: selectedLocation.locationCoordinate, to: .joliet)
            }
        }
        // start location picker
        
        
    }
           
    
    
    // get user location coordinate
    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        
    
        do {
            let update = try await updates.first { $0.location?.coordinate != nil}
            return update?.location?.coordinate
        } catch {
            print("Can not get user location")
            return nil
        }
    }
    
    // function creates route from two locations
    func getDirections(from start: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        Task {
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: start))
            request.destination = MKMapItem(placemark: .init(coordinate: destination))
            request.transportType = .automobile
            
            do {
                let directions = try await MKDirections(request: request).calculate()
                route = directions.routes.first
                // calculate camera position based on polyline coordinates
                cameraPosition = .region(calculateRegion(for: [start, destination]))
                // set starting and ending locations
                startingLocation = start
                endingLocation = destination
            } catch {
                print("No directions found")
            }
        }
    }
       
}

// function to calculate MKCoordinateRegion from coordinates
private func calculateRegion(for coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
    guard !coords.isEmpty else {
        return MKCoordinateRegion()
    }
    
    var minLat = coords[0].latitude
    var maxLat = coords[0].latitude
    var minLon = coords[0].longitude
    var maxLon = coords[0].longitude
    
    for coord in coords {
        minLat = min(minLat, coord.latitude)
        maxLat = max(maxLat, coord.latitude)
        minLon = min(minLon, coord.longitude)
        maxLon = max(maxLon, coord.longitude)
    }
    
    let center = CLLocationCoordinate2D(
        latitude: (minLat + maxLat) / 2,
        longitude: (minLon + maxLon) / 2
    )
    
    let span = MKCoordinateSpan(
        latitudeDelta: (maxLat - minLat) * 1.3, // Add 30% padding
        longitudeDelta: (maxLon - minLon) * 1.3
    )
    
    return MKCoordinateRegion(center: center, span: span)
}

// locations struct
enum Locations: String, CaseIterable, Identifiable {
    case crestHill, joliet, orlandPark
    var id: Self { self }
    
    
}

// extension on locations struct returns location coordinate
extension Locations {
    
    var locationName: String {
        switch self {
        case .crestHill: return "Crest Hill"
        case .joliet: return "Joliet"
        case .orlandPark: return "Orland Park"
        }
        
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        switch self {
        case .crestHill: return .crestHill
        case .joliet: return .joliet
        case .orlandPark: return .orlandPark
        }
    }
}

// extension stores static location coordinates
extension CLLocationCoordinate2D {
    static let crestHill = CLLocationCoordinate2D(latitude: 41.5432, longitude: -88.1408)
    static let joliet = CLLocationCoordinate2D(latitude: 41.5353965, longitude: -88.0816650)
    static let orlandPark = CLLocationCoordinate2D(latitude: 41.61387, longitude: -87.79368)
}


#Preview {
    ContentView()
}
