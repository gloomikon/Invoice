protocol RemoteValue {
    static var `default`: Self { get }
}

extension RemoteValue where Self: CaseIterable {
    static var `default`: Self {
        // swiftlint:disable:next force_unwrapping
        Self.allCases.first!
    }
}
