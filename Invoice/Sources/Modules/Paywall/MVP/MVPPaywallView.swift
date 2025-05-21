import SwiftUI

struct MVPPaywallView: View {

    @ObservedObject var viewModel: MVPPaywallViewModel

    var body: some View {
        PaywallView(viewModel: viewModel, buttonStyle: .primary) {
            Text("Paywall")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.yellow)
    }
}
