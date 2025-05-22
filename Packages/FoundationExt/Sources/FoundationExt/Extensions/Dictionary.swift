public extension Dictionary {
    func add(_ value: Value, for key: Key) -> Self {
        var dict = self
        dict[key] = value
        return dict
    }

    func addIfPresent(_ value: Value?, for key: Key) -> Self {
        var dict = self
        if let value {
            dict[key] = value
        }
        return dict
    }
}
