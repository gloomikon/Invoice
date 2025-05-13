/// Representation of the remote value
public enum RemoteValue<Value: Codable>: Codable {

    /// Remote value is not overridden by the Debug Panel
    case `default`
    /// Remote value is overridden by the Debug Panel
    case selected(Value)
}

public typealias BoolRemoteValue = RemoteValue<Bool>
public typealias StringRemoteValue = RemoteValue<String>

extension RemoteValue: Equatable where Value: Equatable { }
extension RemoteValue: Hashable where Value: Hashable { }
