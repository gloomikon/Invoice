import Core
import DebugPanel
import Depin
import EventKit
import os

extension EventProcessor {

    private static var clients: [AnalyticsClient] {
        @Injected var amplitude: AmplitudeClient
        return [
            amplitude
        ]
    }

    func send(_ name: String, with params: [String: CustomStringConvertible]? = nil) {
        let message = (["🚀 \(name)"] + (params.map { params in
            params.map { param in
                "• \(param.key): \(param.value)"
            }
        } ?? []))
        .joined(separator: "\n")

        Logger.analytics.print(message)
        SimpleLogger.app.log(message)

        Self.clients.sendEvent(name: name, parameters: params)
    }

    func set(_ property: String, with value: String) {
        let message = "📲 \(property)\n • \(value)"
        Logger.analytics.print(message)
        SimpleLogger.app.log(message)
        Self.clients.set(property, with: value)
    }

    func set(property: String, with value: Int) {
        Logger.analytics.print("📲 \(property)\n • \(value)")
        Self.clients.set(property, with: value)
    }

    func increment(_ property: String, value: Int = 1) {
        Logger.analytics.print("➕ \(property) with \(value)")
        Self.clients.increment(property, value: value)
    }

    func decrement(_ property: String, value: Int = 1) {
        Logger.analytics.print("➖ \(property) with \(value)")
        Self.clients.decrement(property, value: value)
    }
}

protocol AnalyticsProperty: CustomStringConvertible {
    var analyticsName: String { get }
}

extension AnalyticsProperty {
    var description: String {
        analyticsName
    }
}

extension AnalyticsProperty where Self: RawRepresentable<String> {

    var analyticsName: String {
        rawValue
    }
}
