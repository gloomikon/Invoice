import SwiftUI

/// StringRemoteValueSetting is used to override some string parameter in the app. For example, if some feature has different possible values, you can pass all the values on choose between them
public struct StringRemoteValueSetting: DisplayableSetting {

    public let id = UUID()
    public var icon: Image? = .init(systemName: "textformat.abc")
    public var backgroundColor: Color? = .init(.systemFill)
    public var tintColor: Color? = .init(.label)

    private let title: String
    private let key: String
    private let values: [String]
    private let colorForValue: (String) -> Color
    private let onChange: ((StringRemoteValue) -> Void)?

    @EnvironmentObject private var viewModel: DebugPanelViewModel

    /// Creates new StringRemoteValueSetting
    /// - Parameters:
    ///   - title: Title of the setting that will be displayed
    ///   - key: Key of the remote value that will be used to save it's status in the storage
    ///   - values: All possible values of the remote setting
    ///   - colorForValue: Which color to use for displaying the selected variant. Default is `.green`
    ///   - onChange: Handler of remote value status change
    public init(
        _ title: String,
        key: String,
        values: [String],
        colorForValue: @escaping (String) -> Color = { _ in .green },
        onChange: ((StringRemoteValue) -> Void)? = nil
    ) {
        self.title = title
        self.key = key
        self.values = values
        self.colorForValue = colorForValue
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
                        viewModel.stringRemoteValue(for: key)
                    },
                    set: { newValue in
                        viewModel.setRemoteValue(newValue, for: key)
                        onChange?(newValue)
                    }
                )
            ){
                Text("Default")
                    .tag(StringRemoteValue.default)
                ForEach(values, id: \.self) { value in
                    Text(value)
                        .tag(StringRemoteValue.selected(value))
                }
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

                        switch viewModel.stringRemoteValue(for: key) {
                        case .default:
                            Text("Default")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        case .selected(let value):
                            Text(value)
                                .font(.footnote)
                                .foregroundStyle(colorForValue(value))
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
