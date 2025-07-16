import Network

/// May not work on simulator
public final class NetworkStatusService {

    public enum Status {
        case connectedViaWiFi
        case connectedViaCellular
        case notConnected

        public var isConnected: Bool {
            switch self {
            case .connectedViaWiFi, .connectedViaCellular:
                true
            case .notConnected:
                false
            }
        }
    }

    private let monitor: NWPathMonitor
    private let queue: DispatchQueue

    private var continuation: AsyncStream<Status>.Continuation?
    private(set) public var currentStatus: Status = .notConnected {
        didSet {
            guard currentStatus != oldValue else { return }
            continuation?.yield(currentStatus)
        }
    }

    public init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue(label: "NetworkStatusMonitor")
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.currentStatus = Self.status(from: path)
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }

    public func statusStream() -> AsyncStream<Status> {
        AsyncStream { continuation in
            self.continuation = continuation
            continuation.yield(currentStatus)

            continuation.onTermination = { _ in
                self.continuation = nil
            }
        }
    }

    private static func status(from path: NWPath) -> Status {
        if path.status == .satisfied {
            if path.usesInterfaceType(.wifi) {
                .connectedViaWiFi
            } else if path.usesInterfaceType(.cellular) {
                .connectedViaCellular
            } else {
                .notConnected
            }
        } else {
            .notConnected
        }
    }
}
