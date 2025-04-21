import Foundation
import CoreLocation

struct WalkRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let distance: Double
    let duration: Int
    let startLatitude: Double
    let startLongitude: Double

    var startLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
    }


    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

class WalkHistoryManager: ObservableObject {
    @Published private(set) var walks: [WalkRecord] = []

    private let storageKey = "walkHistory"

    init() {
        loadHistory()
    }

    func addWalk(distance: Double, duration: Int, startLocation: CLLocationCoordinate2D) {
        let newWalk = WalkRecord(
            id: UUID(),
            date: Date(),
            distance: distance,
            duration: duration,
            startLatitude: startLocation.latitude,
            startLongitude: startLocation.longitude
        )
        walks.insert(newWalk, at: 0)
        saveHistory()
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(walks) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let savedWalks = try? JSONDecoder().decode([WalkRecord].self, from: data) {
            walks = savedWalks
        }
    }
}
