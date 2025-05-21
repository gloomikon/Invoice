enum PaywallAlert: Identifiable {

    case success
    case error(_ text: String)

    var id: String {
        switch self {
        case .success:
            "success"
        case .error:
            "error"
        }
    }
}
