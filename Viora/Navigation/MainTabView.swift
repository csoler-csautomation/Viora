import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") { NavigationStack { HomeView() } }
            Tab("Ask Viora", systemImage: "camera.fill") { NavigationStack { AskVioraView() } }
            Tab("Closet", systemImage: "tshirt.fill") { NavigationStack { ClosetView() } }
            Tab("Trending", systemImage: "sparkles") { NavigationStack { TrendingView() } }
            Tab("Settings", systemImage: "accessibility") { NavigationStack { AccessibilitySettingsView() } }
        }
    }
}
