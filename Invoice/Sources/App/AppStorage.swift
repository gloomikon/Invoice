import Core
import DebugPanel
import FoundationExt

class AppStorage {

    private enum Constant {
        static let deviceUDID = "deviceUDID"
    }

    @Storage("didLaunchApp", default: false)
    var didLaunchApp

    @Storage("didSeePaywall", default: false)
    var didSeePaywall

    private var realIsPremium = false

    var isPremium: Bool {
        get {
            switch DebugPanelStorage.shared.boolRemoteValue(for: "debug_is_premium") {
            case .default:
                realIsPremium
            case .selected(let value):
                value
            }
        }
        set {
            realIsPremium = newValue
        }
    }

    // TODO: - Fix
    private lazy var keychain = KeychainManager(
        settings: KeychainSettings(
            service: "com.harmonyapps.relief.service",
            accessGroup: "WGGBM25LU6.com.harmonyapps.relief",
            synchronizable: true,
            accessibility: .afterFirstUnlock
        )
    )

    var deviceUDID: String {
        get {
            let deviceID: String

            if
                let storedDeviceID = keychain.string(forKey: Constant.deviceUDID),
                storedDeviceID.isValidDeviceID {
                deviceID = storedDeviceID
            } else {
                let newDeviceID = UUID().uuidString
                keychain[Constant.deviceUDID] = newDeviceID
                deviceID = newDeviceID
            }

            return deviceID
        }
        set {
            keychain[Constant.deviceUDID] = newValue
        }
    }
}

private extension String {
    var isValidDeviceID: Bool {
        contains { $0 != "0" && $0 != "-" }
    }
}
