import Foundation

public struct AdvancedLog: Identifiable {

    public enum Severity {
        case info
        case warning
        case error
    }

    public let id = UUID()
    public let date = Date()

    public let severity: Severity?
    public let message: String
    public let issuer: String

    public init(severity: Severity? = nil, message: String, issuer: String) {
        self.severity = severity
        self.message = message
        self.issuer = issuer
    }

    public var debugDescription: String {
        """
        \(date.formatted(date: .complete, time: .standard))
        \(severity.debugDescription) [\(issuer)] - \(message)
        """
    }
}

extension AdvancedLog.Severity? {

    var debugDescription: String {
        switch self {
        case .none:
            "-"
        case .info:
            "ℹ️"
        case .warning:
            "⚠️"
        case .error:
            "❌"
        }
    }
}
