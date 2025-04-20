import UIKit
import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    let route: Route?

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition(latitude: 0, longitude: 0, zoom: 15)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.tiltGestures = false
        mapView.settings.rotateGestures = false
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        guard let route = route else { return }

        let polyline = GMSPolyline(path: route.path)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = UIColor.orange
        polyline.spans = [GMSStyleSpan(style: GMSStrokeStyle.solidColor(.orange))]
        polyline.map = mapView

        let first = route.path.coordinate(at: 0)
        let camera = GMSCameraPosition(latitude: first.latitude, longitude: first.longitude, zoom: 16)
        mapView.animate(to: camera)

        let startMarker = GMSMarker(position: first)
        startMarker.title = "Start"
        startMarker.icon = GMSMarker.markerImage(with: .red)
        startMarker.map = mapView
    }
}
