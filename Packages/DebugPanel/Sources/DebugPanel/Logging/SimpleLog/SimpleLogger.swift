import Combine
import Foundation

public class SimpleLogger: ObservableObject {

    public init() { }

    private let queue = DispatchQueue(
        label: "simple-logger-thread-safe-obj",
        attributes: .concurrent
    )

    private var _logs: [SimpleLog] = []

    public var logs: [SimpleLog] {
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

    public func log(_ text: String) {
        logs.append(SimpleLog(text))
    }

    public func clear() {
        logs = []
    }
}
