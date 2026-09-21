import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack { HomeView() }
            }

            Tab("Ask Stareli", systemImage: "camera.fill") {
                NavigationStack { AskVioraView() }
            }

            Tab("Spaces", systemImage: "square.grid.2x2.fill") {
                NavigationStack { SpacesView() }
            }

            Tab("Shop", systemImage: "bag.fill") {
                NavigationStack { TrendingView() }
            }

            Tab("Profile", systemImage: "accessibility") {
                NavigationStack { AccessibilitySettingsView() }
            }
        }
    }
}
