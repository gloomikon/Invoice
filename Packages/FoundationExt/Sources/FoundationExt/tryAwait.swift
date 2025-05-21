@discardableResult
public func tryAwait(
    @_inheritActorContext @_implicitSelfCapture _ operation: @escaping @Sendable () async throws -> Void,
    @_implicitSelfCapture onCatch: ((Error) async -> Void)? = nil,
    @_implicitSelfCapture onAny: (() -> Void)? = nil
) -> Task<Void, Never> {
    Task {
        do {
            try await operation()
            onAny?()
        } catch {
            await onCatch?(error)
            onAny?()
        }
    }
}
