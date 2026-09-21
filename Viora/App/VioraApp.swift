import SwiftUI
import SwiftData

@main
struct StareliApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [ClosetItem.self, VioraSpace.self])
    }
}
