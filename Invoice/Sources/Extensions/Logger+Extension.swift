import Foundation
import os

extension Logger {

    // swiftlint:disable:next force_unwrapping
    static let analytics = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "analytics")
}
