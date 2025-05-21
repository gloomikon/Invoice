import SwiftUI

struct PaywallHeader<ViewModel: PaywallViewModel>: View {

    @EnvironmentObject private var viewModel: ViewModel

    private var cross: some View {
        Button {
            viewModel.close()
        } label: {
            Cross()
//                .foregroundStyle(.black)
                .frame(width: 15, height: 15)
                .padding(8)
        }
    }

    private var restore: some View {
        Button("Restore") {
            viewModel.restore()
        }
    }

    var body: some View {
        HStack {
            if viewModel.crossVisible {
                cross
            }
            Spacer()
            restore
//                .foregroundStyle(.textSecondary)
                .font(.system(size: 13))
        }
        .padding(.top, 10)
        .padding(.horizontal, 16)
    }
}
