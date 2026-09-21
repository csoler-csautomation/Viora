import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("How can Stareli help?")
                    .font(.largeTitle.bold())

                NavigationLink {
                    AskVioraView()
                } label: {
                    Label("Ask Stareli", systemImage: "camera.fill")
                        .frame(maxWidth: .infinity, minHeight: 64)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityHint("Choose a photo and ask Stareli a visual question")

                GroupBox("Explore") {
                    VStack(alignment: .leading, spacing: 16) {
                        NavigationLink("My Spaces") { SpacesView() }
                        Divider()
                        NavigationLink("Shop") { TrendingView() }
                        Divider()
                        NavigationLink("Accessibility") { AccessibilitySettingsView() }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                }
            }
            .padding()
        }
        .navigationTitle("Stareli")
    }
}
