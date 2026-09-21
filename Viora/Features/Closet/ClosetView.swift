import SwiftUI
import SwiftData

struct ClosetView: View {
    @Query(sort: \ClosetItem.createdAt, order: .reverse) private var items: [ClosetItem]
    @Environment(\.modelContext) private var context
    @State private var showingAdd = false
    var body: some View {
        List {
            if items.isEmpty { ContentUnavailableView("Your closet is empty", systemImage: "tshirt", description: Text("Add clothing you own so Viora can help with your real wardrobe.")) }
            else { ForEach(items) { item in VStack(alignment: .leading) { Text(item.name).font(.headline); Text("\(item.colorDescription) • \(item.category)").foregroundStyle(.secondary); if !item.details.isEmpty { Text(item.details) } }.accessibilityElement(children: .combine) }.onDelete { offsets in for i in offsets { context.delete(items[i]) } } }
        }.navigationTitle("My Closet").toolbar { Button("Add", systemImage: "plus") { showingAdd = true } }.sheet(isPresented: $showingAdd) { AddClosetItemView() }
    }
}

private struct AddClosetItemView: View {
    @Environment(\.dismiss) private var dismiss; @Environment(\.modelContext) private var context
    @State private var name=""; @State private var category=""; @State private var color=""; @State private var details=""
    var body: some View { NavigationStack { Form { TextField("Name", text:$name); TextField("Category", text:$category); TextField("Color description", text:$color); TextField("Details", text:$details, axis:.vertical) }.navigationTitle("Add Clothing").toolbar { ToolbarItem(placement:.cancellationAction){Button("Cancel"){dismiss()}}; ToolbarItem(placement:.confirmationAction){Button("Save"){context.insert(ClosetItem(name:name,category:category,colorDescription:color,details:details));dismiss()}.disabled(name.trimmingCharacters(in:.whitespaces).isEmpty)} } } }
}
