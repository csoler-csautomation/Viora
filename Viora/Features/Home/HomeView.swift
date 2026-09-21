import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("How can Viora help?").font(.largeTitle.bold())
                NavigationLink { AskVioraView() } label: { Label("Ask Viora", systemImage: "camera.fill").frame(maxWidth: .infinity, minHeight: 64) }.buttonStyle(.borderedProminent)
                GroupBox("Explore") {
                    VStack(alignment: .leading, spacing: 16) {
                        NavigationLink("My Closet") { ClosetView() }
                        Divider(); NavigationLink("Trending products") { TrendingView() }
                        Divider(); NavigationLink("Home Assistant") { HomeAssistantView() }
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.vertical, 8)
                }
            }.padding()
        }.navigationTitle("Viora")
    }
}
