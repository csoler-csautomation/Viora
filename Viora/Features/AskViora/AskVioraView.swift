import SwiftUI
import PhotosUI

struct AskVioraView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var question = ""
    @State private var answer = ""
    @State private var isWorking = false

    var body: some View {
        Form {
            Section("Visual input") {
                PhotosPicker(selection: $selectedPhoto, matching: .images) { Label("Choose Photo", systemImage: "photo") }
                    .onChange(of: selectedPhoto) { _, value in Task { imageData = try? await value?.loadTransferable(type: Data.self) } }
                if imageData != nil { Label("Photo ready", systemImage: "checkmark.circle.fill") }
            }
            Section("Ask") {
                TextField("What would you like to know?", text: $question, axis: .vertical).lineLimit(2...5)
                Button { Task { await ask() } } label: { if isWorking { ProgressView() } else { Label("Ask Viora", systemImage: "sparkles") } }
                    .disabled(imageData == nil || question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isWorking)
            }
            if !answer.isEmpty { Section("Viora") { Text(answer).font(.title3).accessibilityLabel("Viora says: \(answer)") } }
        }.navigationTitle("Ask Viora")
    }

    @MainActor private func ask() async {
        guard let imageData else { return }; isWorking = true; defer { isWorking = false }
        do { answer = try await VioraAIClient.shared.analyze(imageData: imageData, question: question) }
        catch { answer = "Viora could not analyze this image right now. Please try again." }
    }
}
