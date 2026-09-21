import Foundation

struct TrendProduct: Identifiable, Codable {
    let id: String; let title: String; let retailer: String; let displayPrice: String?; let imageURL: URL?; let destinationURL: URL; let accessibleDescription: String?
}
