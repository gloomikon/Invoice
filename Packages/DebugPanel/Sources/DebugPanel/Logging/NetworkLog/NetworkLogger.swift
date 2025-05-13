import Combine
import Foundation

public class NetworkLogger: ObservableObject {

    public init() { }

    private let queue = DispatchQueue(
        label: "network-logger-thread-safe-obj",
        attributes: .concurrent
    )

    private var _logs: [NetworkLog] = []

    public var logs: [NetworkLog] {
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

    public func log(_ request: URLRequest, withID id: UUID) {
        guard logs.first(where: { $0.id == id} ) == nil else {
            return
        }
        logs.append(NetworkLog(id: id, request: request))
    }

    public func log(_ response: URLResponse, data: Data, withID id: UUID) {
        guard let idx = logs.firstIndex(where: { $0.id == id} ) else {
            return
        }
        logs[idx].response = response
        logs[idx].data = data
    }

    public func log(_ error: String, withID id: UUID) {
        guard let idx = logs.firstIndex(where: { $0.id == id} ) else {
            return
        }
        logs[idx].error = error
    }

    public func clear() {
        logs = []
    }
}
