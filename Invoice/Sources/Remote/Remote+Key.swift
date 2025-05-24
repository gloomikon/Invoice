extension Remote {

    enum Key: String, RemoteKey, CaseIterable {

        case test

        var key: String {
            rawValue
        }

        var valueType: RemoteValue.Type {
            switch self {
            case .test:
                Value.Test.self
            }
        }
    }
}
