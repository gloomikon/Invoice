import SwiftUI

struct PaywallFooter<ViewModel: PaywallViewModel>: View {

    @EnvironmentObject private var viewModel: ViewModel

    private var termsOfUse: some View {
        Button("Terms of use") {
            viewModel.openTermsOfUse()
        }
    }

    private var privacyPolicy: some View {
        Button("Privacy Policy") {
            viewModel.openPrivacyPolicy()
        }
    }

    var body: some View {
        HStack(spacing: 26) {
            termsOfUse
            privacyPolicy
        }
//        .foregroundStyle(.textSecondary)
        .font(.system(size: 13))
        .padding(.horizontal, 16)
    }
}
