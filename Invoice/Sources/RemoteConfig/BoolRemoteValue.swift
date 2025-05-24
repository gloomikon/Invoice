protocol BoolRemoteValue: RemoteValue, Equatable {

    static var enabled: Self { get }
    static var disabled: Self { get }

    init(_ isEnabled: Bool)
}

extension BoolRemoteValue {

    var isEnabled: Bool {
        self == .enabled
    }

    init(_ isEnabled: Bool) {
        self = isEnabled ? .enabled : .disabled
    }
}
