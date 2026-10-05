import SwiftUI
import MapKit

struct ContentView: View {
    
    // location manager to request user location
    let locationManager = CLLocationManager()
    
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
                    Marker("Destination", systemImage: "tree", coordinate: .crestHill)

                    // Ending location Marker
                    Marker("Destination", systemImage: "tree", coordinate: .joliet)
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
            
        Button("Get Directions") {
            getDirections(to: .joliet)
        }
        
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
    func getDirections(to destination: CLLocationCoordinate2D) {
        Task {
            guard let userLocation = await getUserLocation() else { return }
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: userLocation))
            request.destination = MKMapItem(placemark: .init(coordinate: destination))
            request.transportType = .automobile
            
            do {
                let directions = try await MKDirections(request: request).calculate()
                route = directions.routes.first
                // calculate camera position based on polyline coordinates
                cameraPosition = .region(calculateRegion(for: [userLocation, destination]))
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

// extension stores static location coordinates
extension CLLocationCoordinate2D {
    static let crestHill = CLLocationCoordinate2D(latitude: 41.5432, longitude: -88.1408)
    static let joliet = CLLocationCoordinate2D(latitude: 41.5353965, longitude: -88.0816650)
    static let orlandPark = CLLocationCoordinate2D(latitude: 41.5353965, longitude: -88.0816650)
}


#Preview {
    ContentView()
}
