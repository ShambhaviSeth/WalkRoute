import SwiftUI
import GoogleMaps

struct MainViewController: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var locationManager = LocationManager()
    @State private var route: Route?
    @State private var duration = Constants.defaultWalkDuration
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Length of time")
                .font(.headline)

            HStack(spacing: 8) {
                Text("\(duration)")
                    .font(.largeTitle)
                    .bold()
                Text("minutes")
                    .font(.subheadline)
            }

            Slider(value: Binding(
                get: { Double(duration) },
                set: { duration = Int($0) }
            ), in: 5...60, step: 5)
            .padding(.horizontal)

            Divider()

            if isLoading {
                ProgressView("Generating Route...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                if let route = route {
                    MapView(route: route)
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1))
                    RouteInfoView(route: route)
                }
                Button(route == nil ? "Generate Route" : "Regenerate Route") {
                    startRouteGeneration()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.blue)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
    }

    private func startRouteGeneration() {
        isLoading = true
        guard let location = locationManager.location else {
            isLoading = false
            return
        }

        // Generate two different waypoints for out and back route variation
        let offsetRange = -0.002...0.002
        let waypointA = CLLocationCoordinate2D(
            latitude: location.latitude + Double.random(in: offsetRange),
            longitude: location.longitude + Double.random(in: offsetRange)
        )

        let waypointB = CLLocationCoordinate2D(
            latitude: location.latitude + Double.random(in: offsetRange),
            longitude: location.longitude + Double.random(in: offsetRange)
        )

        generateRoute(from: location, waypoints: [waypointA, waypointB])
    }

    private func generateRoute(from location: CLLocationCoordinate2D, waypoints: [CLLocationCoordinate2D]) {
        RouteGenerator.generateRoute(from: location, durationInMinutes: duration) { newRoute in
            DispatchQueue.main.async {
                self.route = newRoute
                self.isLoading = false
            }
        }
    }
}
