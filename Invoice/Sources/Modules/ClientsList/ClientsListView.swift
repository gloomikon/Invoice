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
            if viewModel.clients.isEmpty {
                EmptyStateView()
            } else {
                List {
                    Section {
                        ForEach(viewModel.clients) { client in
                            ClientRow(client: client)
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
                    .padding(.top, 8)
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
            .padding(12)
            .background(.white, in: .rect(cornerRadius: 16))
            .contentShape(.rect)
        }
    }

    private struct EmptyStateView: View {

        var body: some View {
            VStack(spacing: 12) {
                Icon(systemName: "briefcase")
                    .scaledToFit()
                    .frame(width: 50)

                Text("Looks like you haven’t added any clients.\nCreate one or import them from your contact list")
                    .padding(.horizontal, 20)
                    .spacedFont(.poppins(size: 16, weight: .semiBold))
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.linkedIn.opacity(0.6))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
