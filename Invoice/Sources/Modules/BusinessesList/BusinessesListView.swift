import SwiftUIExt

struct BusinessesListView: View {

    @ObservedObject var viewModel: BusinessesListViewModel

    private var header: some View {
        Text("Businesses")
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

            if viewModel.businesses.isEmpty {
                let text: LocalizedStringKey = if viewModel.searchText.isEmpty {
                    "You haven’t set up any businesses.\nReady to create one?"
                } else {
                    "No businesses found matching your query"
                }
                EmptyStateView(text: text)
            } else {
                SearchBar("", text: $viewModel.searchText)
                    .searchBarStyle(PrimarySearchBarStyle())
                    .colorScheme(.light)
                    .padding(.horizontal, 8)

                List {
                    Section {
                        ForEach(viewModel.businesses) { business in
                            BusinessRow(business: business)
                                .listRowSpacing(.zero)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparatorTint(.linkedIn.opacity(0.1))
                                .listRowBackground(Color.white)
                                .onTapGesture {
                                    viewModel.businessSelected(business)
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let id = viewModel.businesses[index].id
                                viewModel.deleteBusiness(with: id)
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
                    Button("Create business") {
                        viewModel.openCreateBusiness()
                    }
                    .buttonStyle(.primary)
                }
                .padding(.bottom, 24)
                .padding(.top, 6)
                .padding(.horizontal, 16)
                .background(.backgroundPrimary)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.businesses)
        .background(.backgroundPrimary)
    }

    private struct BusinessRow: View {

        let business: Business

        var body: some View {
            HStack {
                Text(verbatim: business.name)
                    .lineLimit(1)
                    .font(.poppins(size: 14, weight: .medium))
                    .foregroundStyle(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Icon(systemName: "chevron.forward")
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.neutral300)
            }
            .padding(16)
            .contentShape(.rect)
        }
    }

    private struct EmptyStateView: View {

        let text: LocalizedStringKey

        var body: some View {
            VStack(spacing: 12) {
                Icon(systemName: "briefcase")
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
