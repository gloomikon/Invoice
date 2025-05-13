import SwiftUI

/// BoolRemoteValue is used to override some boolean values in the app. For instance, whether user
/// is premium whether some feature is enabled
public struct BoolRemoteValueSetting: DisplayableSetting {

    public let id = UUID()
    public var icon: Image? = .init(systemName: "01.circle")
    public var backgroundColor: Color? = .init(.systemFill)
    public var tintColor: Color? = .init(.label)
    
    private let title: String
    private let key: String
    private let onChange: ((BoolRemoteValue) -> Void)?

    @EnvironmentObject private var viewModel: DebugPanelViewModel

    /// Creates new BoolRemoteValueSetting
    /// - Parameters:
    ///   - title: Title of the setting that will be displayed
    ///   - key: Key of the remote value that will be used to save it's status in the storage
    ///   - onChange: Handler of remote value status change
    public init(
        _ title: String,
        key: String,
        onChange: ((BoolRemoteValue) -> Void)? = nil
    ) {
        self.title = title
        self.key = key
        self.onChange = onChange
    }

    public func isSearchable(with text: String) -> Bool {
        title.starts(with: text) ||
        key.starts(with: text)
    }

    public var body: some View {
        Menu {
            Picker(
                "",
                selection: .init(
                    get: {
                        viewModel.boolRemoteValue(for: key)
                    },
                    set: { newValue in
                        viewModel.setRemoteValue(newValue, for: key)
                        onChange?(newValue)
                    }
                )
            ){
                Text("Default")
                    .tag(BoolRemoteValue.default)
                Text("Enabled")
                    .tag(BoolRemoteValue.selected(true))
                Text("Disabled")
                    .tag(BoolRemoteValue.selected(false))
            }
            .labelsHidden()
        } label: {
            HStack(spacing: 16) {
                if let icon {
                    Icon(
                        icon: icon,
                        tintColor: tintColor,
                        backgroundColor: backgroundColor
                    )
                }
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text(title)
                            .foregroundStyle(Color(.label))
                            .font(.headline)
                        
                        Spacer()
                        
                        switch viewModel.boolRemoteValue(for: key) {
                        case .default:
                            Text("Default")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        case .selected(true):
                            Text("Enabled")
                                .font(.footnote)
                                .foregroundStyle(.green)
                        case .selected(false):
                            Text("Disabled")
                                .font(.footnote)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    Text(key)
                        .foregroundStyle(Color(.label).opacity(0.8))
                        .font(.subheadline)
                }
            }
        }
    }
}
