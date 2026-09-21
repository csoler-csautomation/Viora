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
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Choose Photo", systemImage: "photo")
                }
                .accessibilityHint("Selects a photo for Stareli to analyze")
                .onChange(of: selectedPhoto) { _, value in
                    Task {
                        imageData = try? await value?.loadTransferable(type: Data.self)
                    }
                }

                if imageData != nil {
                    Label("Photo ready", systemImage: "checkmark.circle.fill")
                }
            }

            Section("Ask") {
                TextField("What would you like to know?", text: $question, axis: .vertical)
                    .lineLimit(2...5)

                Button {
                    Task { await ask() }
                } label: {
                    if isWorking {
                        ProgressView()
                            .accessibilityLabel("Stareli is analyzing the image")
                    } else {
                        Label("Ask Stareli", systemImage: "sparkles")
                    }
                }
                .disabled(imageData == nil || question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isWorking)
            }

            if !answer.isEmpty {
                Section("Stareli") {
                    Text(answer)
                        .font(.title3)
                        .accessibilityLabel("Stareli says: \(answer)")
                }
            }
        }
        .navigationTitle("Ask Stareli")
    }

    @MainActor
    private func ask() async {
        guard let imageData else { return }
        isWorking = true
        defer { isWorking = false }

        do {
            answer = try await VioraAIClient.shared.analyze(
                imageData: imageData,
                question: question
            )
        } catch {
            answer = "Stareli could not analyze this image right now. Please try again."
        }
    }
}
