import SwiftUI
import GoogleMaps

struct MainViewController: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var locationManager = LocationManager()
    @StateObject private var tracker = LiveLocationTracker()
    @StateObject private var historyManager = WalkHistoryManager()
    @State private var showingHistory = false
    @State private var route: Route?
    @State private var duration = Constants.defaultWalkDuration
    @State private var isLoading = false
    @State private var mapCenter: CLLocationCoordinate2D?

    var body: some View {
        ZStack(alignment: .bottom) {
            MapViewWithTracking(route: route, tracker: tracker, isDarkMode: colorScheme == .dark)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showingHistory = true
                    }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .padding(10)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                }
                Spacer()
            }

            VStack(spacing: 8) {
                Spacer()

                if let route = route {
                    HStack(spacing: 20) {
                        Label("\(Int(route.distance / 1000)) km", systemImage: "figure.walk")
                        Label("\(route.duration / 60) min", systemImage: "clock")
                    }
                    .padding(10)
                    .background(colorScheme == .dark ? Color.black : Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 1)
                }

                HStack {
                    Spacer()
                    Button(action: recenterMap) {
                        Image(systemName: "location.fill")
                            .padding(10)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(.trailing, 20)
                }

                VStack(spacing: 8) {
                    Text("Length of time")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    HStack(spacing: 4) {
                        Text("\(duration)")
                            .font(.title)
                            .bold()
                        Text("minutes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Slider(value: Binding(
                        get: { Double(duration) },
                        set: { duration = Int($0) }
                    ), in: 5...60, step: 5)
                    .padding(.horizontal)

                    Button(action: startRouteGeneration) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                            Text(route == nil ? "Generate Route" : "Regenerate Route")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(colorScheme == .dark ? Color.black : Color.white.opacity(0.9))
                .cornerRadius(20)
                .padding()
            }
        }
        .sheet(isPresented: $showingHistory) {
            WalkHistoryView(historyManager: historyManager)
        }
    }


    private func startRouteGeneration() {
        isLoading = true
        guard let location = locationManager.location else {
            isLoading = false
            return
        }

        RouteGenerator.generateRoute(from: location, durationInMinutes: duration) { newRoute in
            DispatchQueue.main.async {
                self.isLoading = false
                if let newRoute = newRoute {
                    self.route = newRoute
                    historyManager.addWalk(
                        distance: newRoute.distance,
                        duration: newRoute.duration,
                        startLocation: location
                    )
                }
            }
        }
    }

    private func recenterMap() {
        if let currentLocation = tracker.userLocation {
            mapCenter = currentLocation
            NotificationCenter.default.post(name: Notification.Name("RecenterMap"), object: mapCenter)
        }
    }
}
