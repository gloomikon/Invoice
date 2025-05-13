import Combine
import Foundation

public class AdvancedLogger: ObservableObject {

    public init() { }

    private let queue = DispatchQueue(
        label: "advanced-logger-thread-safe-obj",
        attributes: .concurrent
    )

    private var _logs: [AdvancedLog] = []

    public var logs: [AdvancedLog] {
        get {
            queue.sync { [unowned self] in
                _logs
            }
        }
        set {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
            queue.async(flags: .barrier) { [unowned self] in
                _logs = newValue
            }
        }
    }

    public func log(
        severity: AdvancedLog.Severity? = nil,
        message: String,
        issuer: String
    ) {
        let log = AdvancedLog(severity: severity, message: message, issuer: issuer)
        logs.append(log)
    }

    public func log(_ log: AdvancedLog) {
        logs.append(log)
    }

    public func clear() {
        logs = []
    }
}
