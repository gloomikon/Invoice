import SwiftUI

/// SimpleLogsSetting is used to log some simple text information
///
/// Create a shared instance of logger, for example:
/// ```swift
/// extension SimpleLogger {
///     static let app = SimpleLogger()
/// }
/// ```
/// Then use if for logging:
/// ```swift
/// SimpleLogger.app.log("Some log")
/// ```
/// And pass it to setting
/// ```swift
/// SimpleLogSetting("Logs", logger: .app)
/// ```
public struct SimpleLogsSetting: DisplayableSetting {

    public let id = UUID()
    public var icon: Image? = Image(systemName: "list.clipboard")
    public var backgroundColor: Color? = .indigo.opacity(0.25)
    public var tintColor: Color? = .indigo

    private let title: String
    private let logger: SimpleLogger

    public init(_ title: String, logger: SimpleLogger) {
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
            viewModel.openScreen(.simpleLogs(logger: logger))
        }
    }
}
