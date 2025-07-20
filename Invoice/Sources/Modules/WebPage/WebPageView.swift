import SwiftUI

struct WebPageView: View {

    let viewModel: WebPageViewModel

    private var header: some View {
        Text(viewModel.title)
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

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            Rectangle()
                .fill(.neutral300)
                .frame(height: 1)
            WebView(url: viewModel.url)
                .ignoresSafeArea(edges: .bottom)
        }
        .background(.backgroundPrimary)
    }
}
