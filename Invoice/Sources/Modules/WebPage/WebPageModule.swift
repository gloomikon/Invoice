import SwiftUIExt

struct WebPageModule: Module {

    let router: WebPageRouter
    let url: URL
    let title: String

    func build() -> UIViewController {
        let viewModel = WebPageViewModel(
            router: router,
            url: url,
            title: title
        )
        let view = WebPageView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
