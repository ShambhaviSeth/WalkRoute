// MARK: - Route Generator
import Foundation
import GoogleMaps

class RouteGenerator {
    static func generateRoute(from start: CLLocationCoordinate2D, durationInMinutes: Int, completion: @escaping (Route?) -> Void) {
        // Estimate total round-trip walking distance (in meters)
        let metersPerMinute: Double = 80
        let totalDistance = metersPerMinute * Double(durationInMinutes)
        let halfDistance = totalDistance / 2
        let earthRadius: Double = 6371000

        // Calculate lat/lng deltas based on distance
        let deltaLat = (halfDistance / earthRadius) * (180 / .pi)
        let deltaLng = deltaLat / cos(start.latitude * .pi / 180)

        // Create two waypoints for a loop route
        let waypoint1 = CLLocationCoordinate2D(
            latitude: start.latitude + deltaLat,
            longitude: start.longitude + deltaLng
        )

        let waypoint2 = CLLocationCoordinate2D(
            latitude: start.latitude - deltaLat,
            longitude: start.longitude - deltaLng
        )

        let waypointStrings = [waypoint1, waypoint2].map { "\($0.latitude),\($0.longitude)" }.joined(separator: "|")

        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(start.latitude),\(start.longitude)&destination=\(start.latitude),\(start.longitude)&waypoints=\(waypointStrings)&key=\(Constants.googleMapsAPIKey)"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let routes = json["routes"] as? [[String: Any]],
                  let first = routes.first,
                  let overview = first["overview_polyline"] as? [String: Any],
                  let points = overview["points"] as? String,
                  let path = GMSPath(fromEncodedPath: points) else {
                completion(nil)
                return
            }

            let distance = (first["legs"] as? [[String: Any]])?.first?["distance"] as? [String: Any]
            let duration = (first["legs"] as? [[String: Any]])?.first?["duration"] as? [String: Any]

            let distVal = distance?["value"] as? Double ?? 0
            let durVal = duration?["value"] as? Int ?? 0

            completion(Route(path: path, duration: durVal, distance: distVal))
        }.resume()
    }
}
