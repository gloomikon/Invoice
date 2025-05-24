protocol RemoteConfigProvider {

    func start() async throws
    func value<V: RemoteValue>(for key: RemoteKey) -> V?
}
