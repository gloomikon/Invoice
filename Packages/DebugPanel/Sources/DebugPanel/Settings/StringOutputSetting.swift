import SwiftUI

/// StringOutputSetting is used to display some string info. For example, user identifier, push token, etc.
/// Additionally, some action can be triggered on tap. Use `copyToClipboard` to copy the displayed info
public struct StringOutputSetting: DisplayableSetting {

    public let id = UUID()
    public var icon: Image? = .init(systemName: "info.circle")
    public var backgroundColor: Color? = .yellow.opacity(0.15)
    public var tintColor: Color? = .yellow

    private let title: String
    private let info: String
    private let onTap: ((String) -> Void)?

    /// Creates new StringOutputSetting
    /// - Parameters:
    ///   - title: Title of the setting that will be displayed
    ///   - info: The info that will be displayed
    ///   - onTap: Optional action to call when setting was tapped
    public init(
        title: String,
        info: String,
        onTap: ((String) -> Void)? = nil
    ) {
        self.title = title
        self.info = info
        self.onTap = onTap
    }

    public func isSearchable(with text: String) -> Bool {
        title.starts(with: text)
    }

    public var body: some View {
        HStack(spacing: 16) {
            if let icon {
                Icon(
                    icon: icon,
                    tintColor: tintColor,
                    backgroundColor: backgroundColor
                )
            }

            VStack(alignment: .leading) {

                Text(title)
                    .foregroundStyle(Color(.label))
                    .font(.headline)

                Text(info)
                    .foregroundStyle(Color(.label).opacity(0.8))
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .contentShape(.rect)
        .onTapGesture {
            if let onTap {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()

                onTap(info)
            }
        }
    }
}
