import Foundation

struct Product: Identifiable, Codable, Sendable {
    let id: String
    let title: String
    let retailer: String
    let price: Decimal?
    let salePrice: Decimal?
    let currency: String
    let imageURL: URL?
    let productURL: URL
    let description: String?
    let category: String?
    let sku: String?
    let upc: String?

    var spokenSummary: String {
        var parts = [title]
        if let salePrice {
            parts.append("\(salePrice) \(currency)")
        } else if let price {
            parts.append("\(price) \(currency)")
        }
        parts.append("from \(retailer)")
        if let description, !description.isEmpty { parts.append(description) }
        return parts.joined(separator: ". ")
    }
}
