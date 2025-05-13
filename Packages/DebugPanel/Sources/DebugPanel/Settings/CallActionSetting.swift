import SwiftUI

/// CallActionSetting is used to trigger some actions on tap. For example, local notifications can be sent or user
/// can be navigated to some particular flow in the app
public struct CallActionSetting: DisplayableSetting {

    public let id = UUID()
    public var icon: Image? = Image(systemName: "hand.point.up.left.fill")
    public var backgroundColor: Color? = .teal.opacity(0.25)
    public var tintColor: Color? = .teal

    private let title: String
    private let action: () -> Void
    
    /// Creates new CallActionSetting
    /// - Parameters:
    ///   - title: Title of the setting that will be displayed
    ///   - action: Action that will be triggered on setting tap
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
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
            Text(title)
                .foregroundStyle(Color(.label))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(.rect)
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            action()
        }
    }
}
