import SwiftUI

struct PaywallView: View {

    @ObservedObject var viewModel: PaywallViewModel

    var body: some View {
        VStack {
            Spacer()
            Text("Paywall")
            Spacer()
            Button("Continue") {
                viewModel.close()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.mint)
    }
}
