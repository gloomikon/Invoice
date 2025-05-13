import DebugPanel
import Depin
import UIKit

class AppWindow: DebugPanelWindow {

    override var shouldDisplayPanel: Bool {
        #if DEBUG
        true
        #else
        false
        #endif
    }

    override func setup() {
        setupGroups {
            Group("🔮 General") {
                StringOutputSetting(title: "UDID", info: "TBD") {
                    copyToClipboard($0)
                }
                BoolRemoteValueSetting("Premium", key: "debug_is_premium")
            }

            Group("📑 Logs") {
                SimpleLogsSetting("Amplitude", logger: .app)
                NetworkLogsSetting("Networking", logger: .app)
            }
        }
    }
}
