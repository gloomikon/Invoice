import Foundation
import os

public extension Logger {

    enum Severity: String, CaseIterable {
        case debug
        case info
        case warning
        case error
    }

    func print(_ message: @autoclosure () -> String, severity: Severity = .info) {
        #if DEBUG
        let logMessage = message()
        switch severity {
        case .debug:
            debug("\(logMessage, privacy: .public)")
        case .info:
            info("\(logMessage, privacy: .public)")
        case .warning:
            warning("\(logMessage, privacy: .public)")
        case .error:
            error("\(logMessage, privacy: .public)")
        }
        #endif
    }
}
