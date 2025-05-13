import Combine
import SwiftUI

enum Screen: Hashable {

    case simpleLogs(logger: SimpleLogger)

    case networkLogs(logger: NetworkLogger)
    case networkLog(logger: NetworkLogger, id: UUID)

    case advancedLogs(logger: AdvancedLogger)

    static func == (lhs: Screen, rhs: Screen) -> Bool {
        switch (lhs, rhs) {
        case (.simpleLogs, .simpleLogs),
            (.networkLogs, .networkLogs),
            (.networkLog, .networkLog),
            (.advancedLogs, .advancedLogs):
            true
        default:
            false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}

class DebugPanelViewModel: ObservableObject {

    private let storage = DebugPanelStorage.shared

    @Published private var _groups: [Group]
    @Published var path = NavigationPath()

    @Published var searchableString = ""

    var groups: [Group] {
        if searchableString.isEmpty {
            // If search string is empty, show all groups
            _groups
        } else {
            // Otherwise show only settings that are searchable by this string
            // Do not include empty groups
            _groups
                .map { group in
                    let settings = group.settings.filter { setting in
                        setting.isSearchable(with: searchableString)
                    }
                    return Group(
                        id: group.id,
                        title: group.title,
                        settings: settings
                    )
                }
                .filter { group in
                    !group.settings.isEmpty
                }
        }
    }

    init(groups: [Group]) {
        self._groups = groups
    }

    func boolRemoteValue(for key: String) -> BoolRemoteValue {
        storage.boolRemoteValue(for: key)
    }

    func stringRemoteValue(for key: String) -> StringRemoteValue {
        storage.stringRemoteValue(for: key)
    }

    func setRemoteValue(_ value: BoolRemoteValue, for key: String) {
        storage.setRemoteValue(value, for: key)
        objectWillChange.send()
    }

    func setRemoteValue(_ value: StringRemoteValue, for key: String) {
        storage.setRemoteValue(value, for: key)
        objectWillChange.send()
    }

    func openScreen(_ screen: Screen) {
        path.append(screen)
    }
}
