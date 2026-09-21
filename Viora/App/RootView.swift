import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome = false
    var body: some View {
        if hasCompletedWelcome { MainTabView() }
        else { WelcomeView { hasCompletedWelcome = true } }
    }
}

struct WelcomeView: View {
    let continueAction: () -> Void
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            Image(systemName: "eye.circle.fill").font(.system(size: 86)).accessibilityHidden(true)
            Text("Viora").font(.largeTitle.bold())
            Text("See life your way.").font(.title2)
            Text("Visual assistance designed with accessibility at the center.").multilineTextAlignment(.center).foregroundStyle(.secondary)
            Spacer()
            Button("Get Started", action: continueAction).buttonStyle(.borderedProminent).controlSize(.large).frame(maxWidth: .infinity)
        }.padding(28)
    }
}
