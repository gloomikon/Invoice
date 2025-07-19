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
            if viewModel.invoices.isEmpty {
                EmptyStateView()
            } else {

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

                    Text("Start by creating invoice.\nLook professional to your clients")
                        .font(.poppins(size: 14, weight: .medium))
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
