import SwiftUI

public struct NetworkLogsSetting: DisplayableSetting {

    public let id = UUID()
    public var icon: Image? = Image(systemName: "globe")
    public var backgroundColor: Color? = .indigo.opacity(0.25)
    public var tintColor: Color? = .indigo

    private let title: String
    private let logger: NetworkLogger

    public init(_ title: String, logger: NetworkLogger) {
        self.title = title
        self.logger = logger
    }

    public func isSearchable(with text: String) -> Bool {
        title.starts(with: text)
    }

    @EnvironmentObject private var viewModel: DebugPanelViewModel

    public var body: some View {
        HStack(spacing: 16) {
            if let icon {
                Icon(
                    icon: icon,
                    tintColor: tintColor,
                    backgroundColor: backgroundColor
                )
            }
            Text(title)
                .foregroundStyle(Color(.label))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(.rect)
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            viewModel.openScreen(.networkLogs(logger: logger))
        }
    }
}
