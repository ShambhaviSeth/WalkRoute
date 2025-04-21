// MARK: - Route Generator
import Foundation
import GoogleMaps

class RouteGenerator {
    static func generateRoute(from start: CLLocationCoordinate2D, durationInMinutes: Int, completion: @escaping (Route?) -> Void) {
        // Estimate total round-trip walking distance (in meters)
        let metersPerMinute: Double = 80
        let totalDistance = metersPerMinute * Double(durationInMinutes)

        func coordinate(from start: CLLocationCoordinate2D, distanceMeters: Double, bearingDegrees: Double) -> CLLocationCoordinate2D {
            let bearingRadians = bearingDegrees * .pi / 180
            let lat1 = start.latitude * .pi / 180
            let lon1 = start.longitude * .pi / 180
            let angularDistance = distanceMeters / 6371000

            let lat2 = asin(sin(lat1) * cos(angularDistance) +
                            cos(lat1) * sin(angularDistance) * cos(bearingRadians))
            let lon2 = lon1 + atan2(sin(bearingRadians) * sin(angularDistance) * cos(lat1),
                                    cos(angularDistance) - sin(lat1) * sin(lat2))

            return CLLocationCoordinate2D(
                latitude: lat2 * 180 / .pi,
                longitude: lon2 * 180 / .pi
            )
        }

        let distance = Double.random(in: 0.4...0.6) * totalDistance
        let angle1 = Double.random(in: 0...180)
        let angle2 = angle1 + Double.random(in: 100...160)

        let waypoint1 = coordinate(from: start, distanceMeters: distance, bearingDegrees: angle1)
        let waypoint2 = coordinate(from: start, distanceMeters: distance, bearingDegrees: angle2)

        let waypointStrings = [waypoint1, waypoint2].map { "\($0.latitude),\($0.longitude)" }.joined(separator: "|")

        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(start.latitude),\(start.longitude)&destination=\(start.latitude),\(start.longitude)&mode=walking&waypoints=\(waypointStrings)&key=\(Constants.googleMapsAPIKey)"


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
