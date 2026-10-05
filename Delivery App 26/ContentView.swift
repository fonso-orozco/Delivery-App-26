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
            Map(initialPosition: cameraPosition) {
                // location marker
//                Marker("Crest Hill", systemImage: "laptopcomputer", coordinate: .crestHill)
                // current user location marker
                UserAnnotation()
                
                // navigation line
                if let route {
                    MapPolyline(route)
                        .stroke(Color.blue, lineWidth: 4)
                    
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
            } catch {
                print("No directions found")
            }
        }
    }
       
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
