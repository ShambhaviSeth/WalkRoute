import SwiftUI
import GoogleMaps

struct MapViewWithTracking: UIViewRepresentable {
    let route: Route?
    @ObservedObject var tracker: LiveLocationTracker
    let isDarkMode: Bool

    class Coordinator: NSObject {
        var mapView: GMSMapView?
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 15)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.settings.myLocationButton = false
        mapView.isMyLocationEnabled = true

        // Apply map style
        if isDarkMode, let styleURL = Bundle.main.url(forResource: "dark-map-style", withExtension: "json") {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        } else {
            mapView.mapStyle = nil
        }

        context.coordinator.mapView = mapView

        NotificationCenter.default.addObserver(forName: Notification.Name("RecenterMap"), object: nil, queue: .main) { notification in
            if let coord = notification.object as? CLLocationCoordinate2D {
                let camera = GMSCameraPosition.camera(withLatitude: coord.latitude, longitude: coord.longitude, zoom: 15)
                mapView.animate(to: camera)
            }
        }

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Apply theme on update
        do {
            if isDarkMode, let styleURL = Bundle.main.url(forResource: "dark-map-style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                mapView.mapStyle = nil
            }
        } catch {
            print("⚠️ Failed to apply map style: \(error)")
        }
        mapView.clear()

        if let route = route {
            let polyline = GMSPolyline(path: route.path)
            polyline.strokeWidth = 4.0
            polyline.strokeColor = UIColor.systemBlue
            polyline.map = mapView

            let start = route.path.coordinate(at: 0)
            let startMarker = GMSMarker(position: start)
            startMarker.title = "Start"
            startMarker.icon = GMSMarker.markerImage(with: .green)
            startMarker.map = mapView
        }

        if let userCoord = tracker.userLocation {
            let userMarker = GMSMarker(position: userCoord)
            userMarker.title = "You"
            userMarker.icon = GMSMarker.markerImage(with: .blue)
            userMarker.map = mapView
        }
    }
}
