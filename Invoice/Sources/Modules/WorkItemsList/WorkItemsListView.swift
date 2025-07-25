import Core
import SwiftUIExt

struct WorkItemsListView: View {

    @ObservedObject var viewModel: WorkItemsListViewModel

    private var header: some View {
        Text("Items")
            .font(.poppins(size: 22, weight: .semiBold))
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button {
                    viewModel.close()
                } label: {
                    Icon(systemName: "xmark")
                        .scaledToFit()
                        .frame(height: 16)
                        .font(.system(size: 14, weight: .medium))
                }
                .buttonStyle(.icon)
            }
            .foregroundStyle(.textPrimary)
    }

    var body: some View {
        VStack(spacing: .zero) {
            header
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            Rectangle()
                .fill(.neutral300)
                .frame(height: 1)

            if viewModel.workItems.isEmpty {
                let text: LocalizedStringKey = if viewModel.searchText.isEmpty {
                    "Nothing here yet.\nTap below to create your first work item"
                } else {
                    "No items found matching your query"
                }
                EmptyStateView(text: text)
            } else {
                SearchBar("", text: $viewModel.searchText)
                    .searchBarStyle(PrimarySearchBarStyle())
                    .colorScheme(.light)
                    .padding(.horizontal, 8)

                List {
                    Section {
                        ForEach(viewModel.workItems) { workItem in
                            WorkItemRow(workItem: workItem)
                                .listRowSpacing(.zero)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparatorTint(.linkedIn.opacity(0.1))
                                .listRowBackground(Color.white)
                                .onTapGesture {
                                    viewModel.workItemSelected(workItem)
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let id = viewModel.workItems[index].id
                                viewModel.deleteWorkItem(with: id)
                            }
                        }
                    } header: {
                        Text("Name")
                            .textCase(nil)
                            .font(.poppins(size: 12, weight: .medium))
                            .foregroundStyle(.textSecondary)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: .zero) {
                LinearGradient(
                    colors: [.clear, .backgroundPrimary],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 14)
                VStack(spacing: 12) {
                    Button("Create item") {
                        viewModel.openCreateWorkItem()
                    }
                    .buttonStyle(.primary)
                }
                .padding(.bottom, 24)
                .padding(.top, 6)
                .padding(.horizontal, 16)
                .background(.backgroundPrimary)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.workItems)
        .background(.backgroundPrimary)
    }

    private struct WorkItemRow: View {

        @Storage(CurrencyStorageKey.self) private var currency

        let workItem: WorkItem

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: workItem.name)
                        .lineLimit(1)
                        .font(.poppins(size: 14, weight: .medium))
                        .foregroundStyle(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    let price = String(format: "%.2f", workItem.price)
                    Text(verbatim: "\(price) \(currency.abbreviation)")
                        .font(.poppins(size: 12, weight: .medium))
                        .foregroundStyle(.textSecondary)
                }

                Icon(systemName: "chevron.forward")
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.neutral300)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .contentShape(.rect)
        }
    }

    private struct EmptyStateView: View {

        let text: LocalizedStringKey

        var body: some View {
            VStack(spacing: 12) {
                Icon(systemName: "shippingbox")
                    .scaledToFit()
                    .frame(width: 50)

                Text(text)
                    .padding(.horizontal, 20)
                    .spacedFont(.poppins(size: 16, weight: .semiBold))
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.linkedIn.opacity(0.6))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.2), value: text)
        }
    }
}

private struct PrimarySearchBarStyle: SearchBarStyle {

    func configure(_ searchBar: UISearchBar) {
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .textSecondary

        let textField = searchBar.searchTextField
        textField.backgroundColor = .white
        textField.font = .poppins(size: 14)
        textField.textColor = .textPrimary
        textField.tintColor = .textSecondary

        if let leftIcon = textField.leftView as? UIImageView {
             leftIcon.tintColor = .textSecondary
             leftIcon.image = leftIcon.image?.withRenderingMode(.alwaysTemplate)
         }
    }

    var delegate: UISearchBarDelegate? { nil }
}
