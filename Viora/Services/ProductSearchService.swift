import Foundation

struct ProductSearchRequest: Codable, Sendable {
    let query: String
    var maximumPrice: Decimal? = nil
    var retailer: String? = nil
    var limit: Int = 20
}

protocol ProductSearching {
    func search(_ request: ProductSearchRequest) async throws -> [Product]
}

/// The iPhone talks only to Viora's backend.
/// Rakuten credentials and access tokens must never be stored in the app.
final class ProductSearchService: ProductSearching {
    static let shared = ProductSearchService()

    // Configure this with the production Viora backend URL.
    private let endpoint: URL? = nil

    private init() {}

    func search(_ request: ProductSearchRequest) async throws -> [Product] {
        guard let endpoint else { throw ProductSearchError.backendNotConfigured }

        var urlRequest = URLRequest(url: endpoint.appending(path: "v1/products/search"))
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw ProductSearchError.requestFailed
        }
        return try JSONDecoder().decode([Product].self, from: data)
    }
}

enum ProductSearchError: LocalizedError {
    case backendNotConfigured
    case requestFailed

    var errorDescription: String? {
        switch self {
        case .backendNotConfigured: "Product search is not configured yet."
        case .requestFailed: "Product search is temporarily unavailable."
        }
    }
}
