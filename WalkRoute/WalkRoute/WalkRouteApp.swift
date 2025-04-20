import SwiftUI
import GoogleMaps

@main
struct WalkRouteApp: App {
    init() {
        GMSServices.provideAPIKey(Constants.googleMapsAPIKey)
    }

    var body: some Scene {
        WindowGroup {
            MainViewController()
        }
    }
}
