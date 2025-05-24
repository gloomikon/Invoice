protocol RemoteKey {
    var key: String { get }
    var valueType: RemoteValue.Type { get }
}

extension RemoteKey where Self: RawRepresentable, Self.RawValue == String {
    var key: String {
        rawValue
    }
}

protocol TitledRemoteKey: RemoteKey {
    var title: String { get }
}
