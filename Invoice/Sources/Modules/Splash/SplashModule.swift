import SwiftUIExt

struct SplashModule: Module {

    let router: SplashRouter

    func build() -> UIViewController {
        let viewModel = SplashViewModel(
            router: router
        )
        let view = SplashView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
