import Core
import DebugPanel
import FoundationExt
import UIKit

class AppStorage {

    private enum Constant {
        static let deviceUDID = "deviceUDID"
        static let signatureFileName = "signature.png"
    }

    @Storage("didLaunchApp", default: false)
    var didLaunchApp

    @Storage("didSeeMain", default: false)
    var didSeeMain

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

    private lazy var keychain = KeychainManager(
        settings: KeychainSettings(
            service: "com.dmytroyashchenko.invoiceapp",
            accessGroup: "MTR95823HL.com.dmytroyashchenko.invoiceapp",
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

    var userSignature: UIImage? {
        get {
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            let filePath = directory.appendingPathComponent(Constant.signatureFileName).path

            guard FileManager.default.fileExists(atPath: filePath) else { return nil }

            return UIImage(contentsOfFile: filePath)
        }
        set {
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let fileManager = FileManager.default
            let fileUrl = directory.appendingPathComponent(Constant.signatureFileName)

            if let image = newValue, let imageData = image.pngData() {
                try? imageData.write(to: fileUrl)
            } else {
                if fileManager.fileExists(atPath: fileUrl.path) {
                    try? fileManager.removeItem(at: fileUrl)
                }
            }
        }
    }
}

private extension String {
    var isValidDeviceID: Bool {
        contains { $0 != "0" && $0 != "-" }
    }
}
