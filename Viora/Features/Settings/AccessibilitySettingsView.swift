import SwiftUI
struct AccessibilitySettingsView: View {
    @AppStorage("speakResponses") private var speakResponses=true
    @AppStorage("enhancedContrast") private var enhancedContrast=false
    var body: some View { Form { Section("Accessibility") { Toggle("Speak Viora responses",isOn:$speakResponses); Toggle("Enhanced contrast",isOn:$enhancedContrast) }; Section("Design") { Text("Viora supports VoiceOver and Dynamic Type with large touch targets and meaningful labels.") } }.navigationTitle("Accessibility") }
}
