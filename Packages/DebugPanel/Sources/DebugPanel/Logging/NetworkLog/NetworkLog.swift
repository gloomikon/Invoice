import Foundation

public struct NetworkLog: Identifiable {

    public let id: UUID
    public let requestDate: Date
    public let request: URLRequest

    public var data: Data?
    public var response: URLResponse? {
        didSet {
            responseDate = .now
        }
    }
    public var error: String? {
        didSet {
            responseDate = .now
        }
    }
    public var responseDate: Date?

    public init(id: UUID, request: URLRequest) {
        self.id = id
        self.requestDate = .now
        self.request = request
    }

    public var requestMethod: String {
        request.httpMethod!
    }

    public var requestURL: String {
        request.url!.absoluteString
    }

    public var requestHeaders: [String: String]? {
        request.allHTTPHeaderFields
    }

    public var httpBody: Data? {
        request.httpBody
    }

    public var responseStatusCode: Int? {
        (response as? HTTPURLResponse)?.statusCode
    }

    public var responseHeaders: [String: String]? {
        (response as? HTTPURLResponse)?.allHeaderFields.reduce(into: [:]) {
            let key = "\($1.key)"
            let value = "\($1.value)"
            $0[key] = value
        }
    }

    public var duration: Int? {
        responseDate.map { responseDate in
            Int(responseDate.timeIntervalSince(requestDate))
        }
    }

    public var debugDescription: String {
        var string =
        """
        \(requestDate.formatted(date: .complete, time: .standard))
        [\(requestMethod)] \(requestURL)
        """

        if let requestHeaders {
            let headers =
            """
            {
            \(requestHeaders.map { key, value in "    \(key) : \(value)"}.joined(separator: "\n"))
            }
            """

            string += "\n\nRequest Headers:\n\(headers)"
        }

        if let httpBody {
            let body = httpBody.prettyJSON ?? "data is not json"

            string += "\n\nRequest Body:\n\(body)"
        }

        if let statusCode = responseStatusCode {
            string += "\n\nResponse status code:\n\(statusCode)"
        }

        if let responseHeaders {
            let headers =
            """
            {
            \(responseHeaders.map { key, value in "    \(key) : \(value)"}.joined(separator: "\n"))
            }
            """

            string += "\n\nResponse Headers:\n\(headers)"
        }

        if let httpBody = data {
            let body = httpBody.prettyJSON ?? "data is not json"

            string += "\n\nResponse Body:\n\(body)"
        }

        if let error {
            string += "\n\nError: \(error)"
        }

        return string
    }
}
