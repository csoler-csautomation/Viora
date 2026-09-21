import SwiftUI
import SwiftData

struct SpacesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \VioraSpace.createdAt) private var spaces: [VioraSpace]
    @State private var showingAddSpace = false
    @State private var newSpaceName = ""

    var body: some View {
        List {
            Section {
                ForEach(spaces) { space in
                    NavigationLink {
                        SpaceDetailView(space: space)
                    } label: {
                        Label {
                            Text(space.name)
                                .font(.title3.weight(.semibold))
                        } icon: {
                            Image(systemName: space.symbolName)
                                .accessibilityHidden(true)
                        }
                        .frame(minHeight: 52)
                    }
                    .accessibilityLabel(space.name)
                    .accessibilityHint("Opens this space")
                }
                .onDelete { offsets in
                    offsets.map { spaces[$0] }.forEach(modelContext.delete)
                }
            } header: {
                Text("Your spaces")
            } footer: {
                Text("Spaces help Viora remember the visual context that matters to you.")
            }
        }
        .navigationTitle("Spaces")
        .toolbar {
            Button {
                showingAddSpace = true
            } label: {
                Label("Create Space", systemImage: "plus")
            }
            .accessibilityHint("Creates a new personal space")
        }
        .sheet(isPresented: $showingAddSpace) {
            NavigationStack {
                Form {
                    TextField("Space name", text: $newSpaceName)
                        .accessibilityLabel("Space name")
                }
                .navigationTitle("New Space")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingAddSpace = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Create") { createSpace() }
                            .disabled(newSpaceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
        .task { seedSpacesIfNeeded() }
    }

    private func createSpace() {
        let name = newSpaceName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        modelContext.insert(VioraSpace(name: name))
        newSpaceName = ""
        showingAddSpace = false
    }

    private func seedSpacesIfNeeded() {
        guard spaces.isEmpty else { return }
        modelContext.insert(VioraSpace(name: "My Home", symbolName: "house.fill"))
        modelContext.insert(VioraSpace(name: "My Closet", symbolName: "tshirt.fill"))
        modelContext.insert(VioraSpace(name: "Shopping", symbolName: "bag.fill"))
        modelContext.insert(VioraSpace(name: "Technology", symbolName: "desktopcomputer"))
    }
}

private struct SpaceDetailView: View {
    let space: VioraSpace

    var body: some View {
        ContentUnavailableView {
            Label(space.name, systemImage: space.symbolName)
        } description: {
            Text("Viora will remember visual information and conversations saved in this space.")
        } actions: {
            NavigationLink("Ask Viora") { AskVioraView() }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
        .navigationTitle(space.name)
    }
}
