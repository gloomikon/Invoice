import DebugPanel
import Depin
import UIKit

class AppWindow: DebugPanelWindow {

    @Injected private var appStorage: AppStorage

    private let allowedUDIDs = [
        "DDC887E6-E6F0-4DFF-9AD8-2BA2B5C5F7AA"
    ]

    override var shouldDisplayPanel: Bool {
        #if DEBUG
        true
        #else
        allowedUDIDs.contains(appStorage.deviceUDID)
        #endif
    }

    override func setup() {
        setupGroups {
            Group("🔮 General") {
                StringOutputSetting(title: "UDID", info: appStorage.deviceUDID) {
                    copyToClipboard($0)
                }
                BoolRemoteValueSetting("Premium", key: "debug_is_premium")
            }

            Group("📑 Logs") {
                SimpleLogsSetting("Amplitude", logger: .app)
//                 NetworkLogsSetting("Networking", logger: .app)
                AdvancedLogsSetting("Debug", logger: .app)
            }

            Group("🦊 Firebase") {
                Remote.Key.allCases.compactMap { key -> Setting? in
                    if key.valueType is any BoolRemoteValue.Type {
                        return BoolRemoteValueSetting(
                            key.title,
                            key: key.key
                        )
                    }

                    if key.valueType is any StringRemoteValue.Type,
                       let type = key.valueType as? any CaseIterable.Type,
                       let allCases = type.allCases as any Collection as? [any RawRepresentable] {
                        return StringRemoteValueSetting(
                            key.title,
                            key: key.key,
                            values: allCases.compactMap { $0.rawValue as? String }
                        )
                    }

                    return nil
                }
            }
        }
    }
}

private extension Remote.Key {

    var title: String {
        String(describing: self)
            .capitalizedFirst
            .splitByCapitalLetters()
            .joined(separator: " ")
    }
}

private extension String {
    var capitalizedFirst: String {
        guard let first else { return self }
        return first.uppercased() + dropFirst()
    }

    func splitByCapitalLetters() -> [String] {
        let pattern = "([A-Z][a-z]*)"
        let regex = try? NSRegularExpression(pattern: pattern)
        let matches = regex?.matches(in: self, range: NSRange(self.startIndex..., in: self)) ?? []
        return matches.map {
            // swiftlint:disable:next force_unwrapping
            String(self[Range($0.range, in: self)!])
        }
    }
}
