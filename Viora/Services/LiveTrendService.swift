import Foundation

actor LiveTrendService {
    static let shared = LiveTrendService()
    private let endpoint: URL? = nil // Configure only an authorized live retailer backend.
    func fetchTrending() async throws -> [TrendProduct] {
        guard let endpoint else { throw TrendError.liveSourceNotConfigured }
        let (data,response)=try await URLSession.shared.data(from:endpoint.appending(path:"v1/trends"))
        guard let http=response as? HTTPURLResponse,(200..<300).contains(http.statusCode) else { throw TrendError.badResponse }
        return try JSONDecoder().decode([TrendProduct].self,from:data)
    }
}
enum TrendError: Error { case liveSourceNotConfigured, badResponse }
enum AffiliateConfiguration { static let amazonTrackingID = "vioraapp-20" }
