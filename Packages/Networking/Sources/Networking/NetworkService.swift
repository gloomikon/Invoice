import EventKit
import Foundation

public class NetworkService {

    private let session = URLSession.shared

    public func request<T: Decodable, R: Request>(_ request: R) async throws -> T {
        let id = UUID()
        let request = try urlRequest(for: request)
        Event.didMakeRequest(request: request, id: id)
            .send()
        let responseData: Data
        do {
            let (data, response) = try await session.data(for: request)
            Event.didGetResponse(response: response, data: data, id: id)
                .send()
            responseData = data
        } catch {
            Event.didGetError(error: error, id: id)
                .send()
            throw error
        }

        return try JSONDecoder().decode(T.self, from: responseData)
    }

    private func urlRequest(for request: Request) throws -> URLRequest {
        guard
            let path = request.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            var components = URLComponents(string: request.host + path) else {
            throw NetworkError("Invalid URL", code: 1)
        }

        components.queryItems = request.queryItems

        guard let url = components.url else {
            throw NetworkError("Invalid URL", code: 1)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body.flatMap { body in
            if let body = body as? Data {
                body
            } else {
                try? JSONEncoder().encode(body)
            }
        }
        urlRequest.httpMethod = request.method.rawValue

        return urlRequest
    }
}
