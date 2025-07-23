import Core
import SwiftUI

struct SettingsView: View {

    @ObservedObject var viewModel: SettingsViewModel

    private var version: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }

    @State private var userIDCopiedToastIsShown = false

    private var header: some View {
        Text("Settings")
            .font(.poppins(size: 22, weight: .semiBold))
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button {
                    viewModel.close()
                } label: {
                    Icon(systemName: "chevron.backward")
                        .scaledToFit()
                        .frame(height: 18)
                        .font(.system(size: 14, weight: .medium))
                }
                .buttonStyle(.icon)
            }
            .foregroundStyle(.textPrimary)
    }

    private var mainSection: some View {
        Section {
            Row(
                title: "Clients",
                subtitle: nil,
                icon: Icon(systemName: "person.and.background.dotted")
                    .scaledToFit()
                    .foregroundStyle(.linkedIn)
                    .frame(width: 18, height: 18)
                    .frame(width: 28, height: 28)
                    .background(.linkedIn.opacity(0.1), in: .rect(cornerRadius: 8)),
                trailingIcon: Icon(systemName: "chevron.forward")
            ) {
                viewModel.openClientsList()
            }

            Row(
                title: "Businesses",
                subtitle: nil,
                icon: Icon(systemName: "briefcase")
                    .scaledToFit()
                    .foregroundStyle(.linkedIn)
                    .frame(width: 20, height: 20)
                    .frame(width: 28, height: 28)
                    .background(.linkedIn.opacity(0.1), in: .rect(cornerRadius: 8)),
                trailingIcon: Icon(systemName: "chevron.forward")
            ) {
                viewModel.openBusinessesList()
            }

            Row(
                title: "Items",
                subtitle: nil,
                icon: Icon(systemName: "shippingbox")
                    .scaledToFit()
                    .foregroundStyle(.linkedIn)
                    .frame(width: 18, height: 18)
                    .frame(width: 28, height: 28)
                    .background(.linkedIn.opacity(0.1), in: .rect(cornerRadius: 8)),
                trailingIcon: Icon(systemName: "chevron.forward")
            ) {
                viewModel.openItemsList()
            }
        }
    }

    private var secondarySection: some View {
        Section {
            Row(
                title: "Rate the app",
                subtitle: nil,
                icon: Icon(systemName: "star")
                    .scaledToFit()
                    .foregroundStyle(.linkedIn)
                    .frame(width: 18, height: 18)
                    .frame(width: 28, height: 28)
                    .background(.linkedIn.opacity(0.1), in: .rect(cornerRadius: 8)),
                trailingIcon: nil
            ) {
                viewModel.rateTheApp()
            }

            Row(
                title: "User ID",
                subtitle: LocalizedStringKey(stringLiteral: viewModel.udid),
                icon: Icon(systemName: "person.text.rectangle")
                    .scaledToFit()
                    .foregroundStyle(.linkedIn)
                    .frame(width: 18, height: 18)
                    .frame(width: 28, height: 28)
                    .background(.linkedIn.opacity(0.1), in: .rect(cornerRadius: 8)),
                trailingIcon: Icon(.copySquares)
            ) {
                HapticPlayer.fire(.selection)
                UIPasteboard.general.string = viewModel.udid
                userIDCopiedToastIsShown = true
            }
        }
    }

    private var infoSection: some View {
        Section {
            Row(
                title: "Restore Purchases",
                subtitle: nil,
                icon: Icon(systemName: "arrow.triangle.2.circlepath")
                    .rotationEffect(.degrees(45))
                    .scaledToFit()
                    .foregroundStyle(.linkedIn)
                    .frame(width: 20, height: 20)
                    .padding(4)
                    .background(.linkedIn.opacity(0.1), in: .rect(cornerRadius: 8)),
                trailingIcon: Icon(systemName: "chevron.forward")
            ) {
                viewModel.restore()
            }

            Row(
                title: "Terms of Service",
                subtitle: nil,
                icon: Icon(systemName: "doc")
                    .scaledToFit()
                    .foregroundStyle(.linkedIn)
                    .frame(width: 16, height: 16)
                    .padding(6)
                    .background(.linkedIn.opacity(0.1), in: .rect(cornerRadius: 8)),
                trailingIcon: Icon(systemName: "chevron.forward")
            ) {
                viewModel.openTermsOfUse()
            }

            Row(
                title: "Privacy Policy",
                subtitle: nil,
                icon: Icon(systemName: "lock.shield")
                    .scaledToFit()
                    .foregroundStyle(.linkedIn)
                    .frame(width: 16, height: 16)
                    .frame(width: 28, height: 28)
                    .background(.linkedIn.opacity(0.1), in: .rect(cornerRadius: 8)),
                trailingIcon: Icon(systemName: "chevron.forward")
            ) {
                viewModel.openPrivacyPolicy()
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            Rectangle()
                .fill(.neutral300)
                .frame(height: 1)
            List {
                mainSection
                secondarySection
                infoSection
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .listStyle(.insetGrouped)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                LinearGradient(
                    colors: [.backgroundPrimary.opacity(0), .backgroundPrimary],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 20)

                Text("Version \(version)")
                Text("© Invoice Maker")
            }
            .font(.poppins(size: 12))
            .foregroundStyle(.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 8)
            .background {
                Color.backgroundPrimary
                    .padding(.top, 20)
            }
        }
        .background(.backgroundPrimary)
        .toast(
            isPresented: $userIDCopiedToastIsShown,
            location: .bottom,
            toast: {
                ToastView(title: "Copied to clipboard")
            }
        )
    }

    private struct ToastView: View {

        let title: LocalizedStringKey

        var body: some View {
            Text(title)
                .font(.poppins(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.textPrimary, in: .rect(cornerRadius: 12))
                .padding(16)
        }
    }

    private struct Row<MainIcon: View>: View {

        let title: LocalizedStringKey
        let subtitle: LocalizedStringKey?
        let icon: MainIcon
        let trailingIcon: Icon?
        let action: () -> Void

        var body: some View {
            Button {
                action()
            } label: {
                HStack(spacing: 12) {
                    icon

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.poppins(size: 14, weight: .medium))
                            .foregroundStyle(.textPrimary)
                        if let subtitle {
                            Text(subtitle)
                                .font(.poppins(size: 12))
                                .foregroundStyle(.textSecondary)
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if let trailingIcon {
                        trailingIcon
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.neutral300)
                    }
                }
                .padding(12)
                .contentShape(.rect)
            }
            .buttonStyle(.empty)
            .listRowInsets(EdgeInsets())
            .listRowSeparatorTint(.linkedIn.opacity(0.1))
            .listRowBackground(Color.white)
        }
    }
}
