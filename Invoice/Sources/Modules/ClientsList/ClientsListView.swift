import SwiftUIExt

struct ClientsListView: View {

    @ObservedObject var viewModel: ClientsListViewModel

    private var header: some View {
        Text("Clients")
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
            SearchBar("", text: $viewModel.searchText)
                .searchBarStyle(PrimarySearchBarStyle())
                .colorScheme(.light)
                .padding(.horizontal, 8)

            if viewModel.clients.isEmpty {
                let text: LocalizedStringKey = if viewModel.searchText.isEmpty {
                    "Looks like you haven’t added any clients.\nCreate one or import them from your contact list"
                } else {
                    "No clients found matching your query"
                }
                EmptyStateView(text: text)
            } else {
                List {
                    Section {
                        ForEach(viewModel.clients) { client in
                            ClientRow(client: client)
                                .listRowSpacing(.zero)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparatorTint(.linkedIn.opacity(0.1))
                                .listRowBackground(Color.white)
                                .onTapGesture {
                                    viewModel.clientSelected(client)
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let id = viewModel.clients[index].id
                                viewModel.deleteClient(with: id)
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
                    if viewModel.clients.isEmpty {
                        Button("Import from contacts") {
                            pickContacts { contacts in
                                viewModel.importedContacts(contacts)
                            }
                        }
                        .buttonStyle(.secondary)
                    }

                    Button("Create client") {
                        viewModel.openCreateClient()
                    }
                    .buttonStyle(.primary)
                }
                .padding(.bottom, 24)
                .padding(.top, 6)
                .padding(.horizontal, 16)
                .background(.backgroundPrimary)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.clients)
        .background(.backgroundPrimary)
    }

    private struct ClientRow: View {

        let client: Client

        var body: some View {
            HStack {
                Text(verbatim: client.name)
                    .lineLimit(1)
                    .font(.poppins(size: 14, weight: .medium))
                    .foregroundStyle(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Icon(systemName: "chevron.forward")
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.neutral300)
            }
            .padding(.horizontal, 16)
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
