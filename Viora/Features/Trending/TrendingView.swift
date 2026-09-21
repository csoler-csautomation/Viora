import SwiftUI

struct TrendingView: View {
    @State private var products:[TrendProduct]=[]; @State private var isLoading=false; @State private var message:String?
    var body: some View {
        Group {
            if isLoading { ProgressView("Updating real products…") }
            else if products.isEmpty { ContentUnavailableView("No live products available", systemImage:"sparkles", description:Text(message ?? "Viora only displays products from authorized live retailer sources. Demo or fabricated products are never shown.")) }
            else { List(products) { product in Link(destination:product.destinationURL) { VStack(alignment:.leading,spacing:6) { Text(product.title).font(.headline); Text(product.retailer).foregroundStyle(.secondary); if let price=product.displayPrice { Text(price).fontWeight(.semibold) } }.accessibilityElement(children:.combine) } } }
        }.navigationTitle("Trending").task { await load() }.refreshable { await load() }
    }
    @MainActor private func load() async { isLoading=true; defer{isLoading=false}; do { products=try await LiveTrendService.shared.fetchTrending(); message=products.isEmpty ? "No current retailer products were returned." : nil } catch { products=[]; message="Live retailer data is unavailable right now. Pull to refresh later." } }
}
