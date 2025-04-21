import SwiftUI

struct WalkHistoryView: View {
    @ObservedObject var historyManager: WalkHistoryManager

    var body: some View {
        NavigationView {
            List(historyManager.walks) { walk in
                VStack(alignment: .leading, spacing: 6) {
                    Text(walk.formattedDate)
                        .font(.headline)
                    HStack {
                        Label("\(String(format: "%.2f", walk.distance / 1000)) km", systemImage: "figure.walk")
                        Spacer()
                        Label("\(walk.duration / 60) min", systemImage: "clock")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Walk History")
        }
    }
}
