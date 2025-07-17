import SwiftUI

struct WebPageView: View {

    let viewModel: WebPageViewModel

    private var header: some View {
        Text(viewModel.title)
            .font(.system(size: 18, weight: .semibold))
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Icon(systemName: "chevron.backward")
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.leading, 16)
                    .onTapGesture {
                        viewModel.close()
                    }
            }
    }

    var body: some View {
        VStack {
            header
            WebView(url: viewModel.url)
                .ignoresSafeArea(edges: .bottom)
        }
        .background(.background)
    }
}
