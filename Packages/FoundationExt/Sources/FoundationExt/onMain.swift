public func onMain(@_implicitSelfCapture _ action: @escaping () -> Void) {
    Task { @MainActor in
        action()
    }
}
