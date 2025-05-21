public func tryAsync(
    @_inheritActorContext @_implicitSelfCapture _ operation: @escaping @Sendable () async throws -> Void,
    @_implicitSelfCapture onCatch: ((Error) -> Void)? = nil,
    @_implicitSelfCapture onAny: (() -> Void)? = nil
) async {
    do {
        try await operation()
        onAny?()
    } catch {
        onCatch?(error)
        onAny?()
    }
}
