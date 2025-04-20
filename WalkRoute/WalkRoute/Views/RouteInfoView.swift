import SwiftUI

struct RouteInfoView: View {
    let route: Route

    var body: some View {
        VStack(alignment: .leading) {
            Text("Distance: \(route.distance / 1000, specifier: "%.2f") km")
            Text("Duration: \(route.duration / 60) min")
        }.padding()
    }
}

