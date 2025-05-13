import Foundation

public enum SecurityClass: RawRepresentable, CaseIterable {

    public typealias RawValue = String

    case genericPassword
    case internetPassword
    case certificate
    case key
    case identity

    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecClassGenericPassword):
            self = .genericPassword
        case String(kSecClassInternetPassword):
            self = .internetPassword
        case String(kSecClassCertificate):
            self = .certificate
        case String(kSecClassKey):
            self = .key
        case String(kSecClassIdentity):
            self = .identity
        default:
            self = .genericPassword
        }
    }

    public var rawValue: String {
        switch self {
        case .genericPassword:
            return String(kSecClassGenericPassword)
        case .internetPassword:
            return String(kSecClassInternetPassword)
        case .certificate:
            return String(kSecClassCertificate)
        case .key:
            return String(kSecClassKey)
        case .identity:
            return String(kSecClassIdentity)
        }
    }
}
