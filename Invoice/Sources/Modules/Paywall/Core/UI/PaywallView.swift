import SwiftUI

struct AnyButtonStyle: ButtonStyle {
    private let _makeBody: (Configuration) -> AnyView

    init<S: ButtonStyle>(_ style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    init(_ style: any ButtonStyle) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

struct PaywallView<
    Header: View,
    Content: View,
    Footer: View,
    ViewModel: PaywallViewModel,
    ButtonStyle: SwiftUI.ButtonStyle
>: View {

    @ObservedObject var viewModel: ViewModel
    let buttonStyle: ButtonStyle
    @ViewBuilder var header: Header
    @ViewBuilder var content: Content
    @ViewBuilder var footer: Footer

    @Environment(\.paywallLayout) private var paywallLayout
    @Environment(\.paywallButtonBottomPadding) private var paywallButtonBottomPadding

    private var buyButton: some View {
        Button(viewModel.buttonTitle) {
            viewModel.buy()
        }
        .buttonStyle(buttonStyle)
        .padding(.horizontal, 20)
        .padding(.bottom, paywallButtonBottomPadding)
        .overlay(alignment: .bottom) {
            footer.environmentObject(viewModel)
        }
        .layoutPriority(1)
    }

    var body: some View {
        let view = paywallLayout.body(
            content: PaywallLayoutContent(
                header: AnyView(header.environmentObject(viewModel)),
                content: AnyView(content.frame(maxHeight: .infinity)),
                footer: AnyView(buyButton)
            )
        )
        AnyView(view)
            .overlay {
                ZStack {
                    SystemBlurView(style: .light)
                        .ignoresSafeArea()

                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .opacity(viewModel.isLoading ? 1 : 0)
                .animation(.easeInOut(duration: 0.25), value: viewModel.isLoading)
            }
            .alert(item: $viewModel.alert) { type in
                switch type {
                case .success:
                    Alert(
                        title: Text("Success"),
                        message: Text("We hope you'll enjoy our app!"),
                        dismissButton: .default(Text("OK")) {
                            viewModel.close()
                        }
                    )
                case .error(let text):
                    Alert(
                        title: Text("Oops!"),
                        message: Text(text),
                        dismissButton: .default(Text("OK")) {
                            viewModel.isLoading = false
                        }
                    )
                }
            }
    }
}

extension PaywallView where Header == PaywallHeader<ViewModel> {

    /// Creates PaywallView with default header
    init(
        viewModel: ViewModel,
        buttonStyle: ButtonStyle,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            viewModel: viewModel,
            buttonStyle: buttonStyle,
            header: { PaywallHeader<ViewModel>() },
            content: content,
            footer: footer
        )
    }
}

extension PaywallView where Footer == PaywallFooter<ViewModel> {

    /// Creates PaywallView with default footer
    init(
        viewModel: ViewModel,
        buttonStyle: ButtonStyle,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            viewModel: viewModel,
            buttonStyle: buttonStyle,
            header: header,
            content: content,
            footer: { PaywallFooter<ViewModel>() }
        )
    }
}

extension PaywallView where Header == PaywallHeader<ViewModel>, Footer == PaywallFooter<ViewModel> {

    /// Creates PaywallView with default header and footer
    init(
        viewModel: ViewModel,
        buttonStyle: ButtonStyle,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            viewModel: viewModel,
            buttonStyle: buttonStyle,
            header: { PaywallHeader<ViewModel>() },
            content: content,
            footer: { PaywallFooter<ViewModel>() }
        )
    }
}

struct SystemBlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        return UIVisualEffectView(effect: blurEffect)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
