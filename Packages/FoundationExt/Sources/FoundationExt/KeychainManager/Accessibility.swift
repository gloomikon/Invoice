import Foundation

public enum Accessibility {
    case afterFirstUnlock
    case afterFirstUnlockThisDeviceOnly
    case whenUnlocked
    case whenUnlockedThisDeviceOnly

    var stringValue: String {
        let result: CFString = switch self {
        case .afterFirstUnlock:
            kSecAttrAccessibleAfterFirstUnlock
        case .afterFirstUnlockThisDeviceOnly:
            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .whenUnlocked:
            kSecAttrAccessibleWhenUnlocked
        case .whenUnlockedThisDeviceOnly:
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        }
        return String(result)
    }
}
