import SwiftUIExt

struct MainView: View {

    @ObservedObject var viewModel: MainViewModel

    private var header: some View {
        HStack {
            Text("Invoices")
                .font(.poppins(size: 27, weight: .semiBold))
                .foregroundStyle(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Icon(.settings)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(.neutral700)
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            header
                .padding(.horizontal, 16)
            if viewModel.allInvoices.isEmpty {
                EmptyStateView()
            } else {
                ListView(
                    total: viewModel.total,
                    invoices: viewModel.invoices,
                    paidStatus: $viewModel.paidStatus
                )
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 12)
        .background(.backgroundPrimary)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: .zero) {
                LinearGradient(
                    colors: [.clear, .backgroundPrimary],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 14)
                Button("Create invoice") {

                }
                .buttonStyle(.primary)
                .padding(.bottom, 24)
                .padding(.top, 6)
                .padding(.horizontal, 16)
                .background(.backgroundPrimary)
            }
        }
    }
}

private extension MainView {

    struct ListView: View {

        let total: String
        let invoices: [Invoice]
        @Binding var paidStatus: Invoice.PaidStatus?

        var body: some View {
            VStack(spacing: 28) {
                Picker("", selection: $paidStatus) {
                    Text("All")
                        .font(.poppins(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                        .tag(Optional<Invoice.PaidStatus>.none)
                    Text("Paid")
                        .tag(Invoice.PaidStatus.paid)
                    Text("Unpaid")
                        .tag(Invoice.PaidStatus.unpaid)
                }
                .pickerStyle(.segmented)
                .colorScheme(.light)
            }

            if let paidStatus, invoices.isEmpty {
                let text: LocalizedStringKey = switch paidStatus {
                case .unpaid:
                    "Zero unpaid — that’s a win"
                case .paid:
                    "No paid invoices so far"
                }
                EmptyStateView(text: text)
            } else {
                Text("Total: \(total)")
                    .font(.poppins(size: 14, weight: .medium))
                    .foregroundStyle(.textSecondary)
                    .padding(.top, 20)

                List(invoices) { invoice in
                    invoice
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .listRowSpacing(8)
            }
        }

        private struct EmptyStateView: View {

            let text: LocalizedStringKey

            var body: some View {

                VStack(spacing: 12) {
                    Icon(systemName: "doc.viewfinder")
                        .scaledToFit()
                        .frame(width: 40)

                    Text(text)
                        .font(.poppins(size: 16, weight: .medium))
                }
                .foregroundStyle(.linkedIn.opacity(0.6))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    struct EmptyStateView: View {

        var body: some View {
            GeometryReader { proxy in
                let width = proxy.size.width
                let proportion = width / 375
                let maxWidth = 526 * proportion
                let offset = max(0, (maxWidth - width) / 2)

                ZStack {
                    Circle()
                        .stroke(
                            .linkedIn.opacity(0.2),
                            lineWidth: 1
                        )
                        .frame(width: 152 * proportion, height: 152 * proportion)

                    Circle()
                        .stroke(
                            .linkedIn.opacity(0.15),
                            lineWidth: 1
                        )
                        .frame(width: 247 * proportion, height: 247 * proportion)

                    Circle()
                        .stroke(
                            .linkedIn.opacity(0.1),
                            lineWidth: 1
                        )
                        .frame(width: 339 * proportion, height: 339 * proportion)

                    Circle()
                        .stroke(
                            .linkedIn.opacity(0.07),
                            lineWidth: 1
                        )
                        .frame(width: 430 * proportion, height: 430 * proportion)

                    Circle()
                        .stroke(
                            .linkedIn.opacity(0.05),
                            lineWidth: 1
                        )
                        .frame(width: 526 * proportion, height: 526 * proportion)

                    Icon(.documentBold)
                        .scaledToFit()
                        .frame(width: 53 * proportion)
                        .foregroundStyle(.linkedIn.opacity(0.6))

                    Icon(.strangeThing)
                        .scaledToFit()
                        .frame(width: 25 * proportion)
                        .foregroundStyle(.linkedIn.opacity(0.4))
                        .alignmentGuide(HorizontalAlignment.center) {
                            $0[HorizontalAlignment.center] - 25 * proportion
                        }
                        .alignmentGuide(VerticalAlignment.center) {
                            $0[VerticalAlignment.center] + 144 * proportion
                        }

                    Icon(.emptyWallet)
                        .scaledToFit()
                        .frame(width: 22 * proportion)
                        .foregroundStyle(.linkedIn.opacity(0.4))
                        .alignmentGuide(HorizontalAlignment.center) {
                            $0[HorizontalAlignment.center] - 95 * proportion
                        }
                        .alignmentGuide(VerticalAlignment.center) {
                            $0[VerticalAlignment.center] + 17 * proportion
                        }

                    Icon(.document)
                        .scaledToFit()
                        .frame(width: 18 * proportion)
                        .foregroundStyle(.linkedIn.opacity(0.4))
                        .alignmentGuide(HorizontalAlignment.center) {
                            $0[HorizontalAlignment.center] + 95 * proportion
                        }
                        .alignmentGuide(VerticalAlignment.center) {
                            $0[VerticalAlignment.center] + 110 * proportion
                        }

                    Icon(.databaseStack)
                        .scaledToFit()
                        .frame(width: 16 * proportion)
                        .foregroundStyle(.linkedIn.opacity(0.4))
                        .alignmentGuide(HorizontalAlignment.center) {
                            $0[HorizontalAlignment.center] + 120 * proportion
                        }
                        .alignmentGuide(VerticalAlignment.center) {
                            $0[VerticalAlignment.center] - 83 * proportion
                        }

                    Icon(.receiptItem)
                        .scaledToFit()
                        .frame(width: 25 * proportion)
                        .foregroundStyle(.linkedIn.opacity(0.4))
                        .alignmentGuide(HorizontalAlignment.center) {
                            $0[HorizontalAlignment.center] - 97 * proportion
                        }
                        .alignmentGuide(VerticalAlignment.center) {
                            $0[VerticalAlignment.center] - 112 * proportion
                        }

                    Text("No invoices to show.\nHit the button and create one!")
                        .font(.poppins(size: 16, weight: .medium))
                        .foregroundStyle(.linkedIn.opacity(0.6))
                        .alignmentGuide(VerticalAlignment.center) {
                            $0[VerticalAlignment.center] - 200 * proportion
                        }
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: -offset)
            }
        }
    }
}

extension Invoice: View {

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Text(title)
                    .font(.poppins(size: 16, weight: .semiBold))
                    .foregroundStyle(.textPrimary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(formattedAmount)
                    .font(.poppins(size: 16, weight: .medium))
                    .foregroundStyle(.textPrimary)
            }

            HStack(spacing: 8) {
                Text(date.formatted(.dateTime.day().month(.abbreviated)))
                    .font(.poppins(size: 14))
                    .foregroundStyle(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("due \(dueDays)d")
                    .font(.poppins(size: 14))
                    .foregroundStyle(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(16)
        .background(.white, in: .rect(cornerRadius: 10))
    }

    private static let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        return formatter
    }()

    var formattedAmount: String {
        let formatter = Self.amountFormatter
        formatter.currencySymbol = currency.symbol
        return formatter.string(from: NSNumber(value: sum)) ?? "\(sum)\(currency.symbol)"
    }

}
