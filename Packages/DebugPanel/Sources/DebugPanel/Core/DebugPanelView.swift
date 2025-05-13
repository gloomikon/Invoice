import SwiftUI

struct DebugPanelView: View {

    @ObservedObject var viewModel: DebugPanelViewModel

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                ForEach(viewModel.groups, id: \.id) { group in
                    Section {
                        ForEach(group.settings, id: \.id) { setting in
                            if let setting = setting as? (any DisplayableSetting) {
                                AnyView(setting)
                                    .environmentObject(viewModel)
                            }
                        }
                    } header: {
                        Text(verbatim: group.title)
                            .font(.headline)
                            .foregroundStyle(Color.secondary)
                    }
                    .headerProminence(.standard)
                }
            }
            .searchable(text: $viewModel.searchableString, placement: .navigationBarDrawer(displayMode: .always))
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case let .simpleLogs(logger):
                    SimpleLogsView(logger: logger)
                case let .networkLogs(logger):
                    NetworkLogsView(logger: logger)
                        .environmentObject(viewModel)
                case let .networkLog(logger, id):
                    NetworkLogDetailView(logger: logger, id: id)
                case let .advancedLogs(logger):
                    AdvancedLogsView(logger: logger)
                }
            }
            .navigationTitle("🦦 Debug Panel 🦦")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
