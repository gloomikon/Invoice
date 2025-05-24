import FirebaseRemoteConfig

class FirebaseRemoteConfigProvider: RemoteConfigProvider {

    private lazy var config = RemoteConfig.remoteConfig()

    func start() async throws {
        try await config.fetchAndActivate()
    }

    func value<V: RemoteValue>(for key: RemoteKey) -> V? {
        if let type = key.valueType as? any BoolRemoteValue.Type {
            config.bool(for: key).flatMap { type.init($0) } as? V
        } else if let type = key.valueType as? any StringRemoteValue.Type {
            config.string(for: key).flatMap { type.init(rawValue: $0) } as? V
        } else {
            nil
        }
    }
}

private extension RemoteConfig {

    func bool(for key: RemoteKey) -> Bool? {
        let string = self[key.key].stringValue
        if string.isEmpty { return nil }
        return string == "true"
    }

    func string(for key: RemoteKey) -> String? {
        let string = self[key.key].stringValue
        if string.isEmpty { return nil }
        return string
    }
}
