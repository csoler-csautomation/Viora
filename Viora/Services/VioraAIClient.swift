import Foundation

actor VioraAIClient {
    static let shared = VioraAIClient()

    // Configure the Stareli HTTPS backend here. Never embed the OpenAI API key in iOS.
    private let endpoint: URL? = nil

    func analyze(imageData: Data, question: String) async throws -> String {
        guard let endpoint else { throw StareliAIError.backendNotConfigured }

        var request = URLRequest(url: endpoint.appending(path: "v1/vision/analyze"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(
            VisionRequest(
                question: question,
                imageBase64: imageData.base64EncodedString()
            )
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw StareliAIError.badResponse
        }

        return try JSONDecoder().decode(VisionResponse.self, from: data).answer
    }
}

private struct VisionRequest: Encodable {
    let question: String
    let imageBase64: String
}

private struct VisionResponse: Decodable {
    let answer: String
}

enum StareliAIError: Error {
    case backendNotConfigured
    case badResponse
}
