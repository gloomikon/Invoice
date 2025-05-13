import FoundationExt

class AppInfoProvider {

    private enum Constant {
        static let deviceUDID = "deviceUDID"
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
