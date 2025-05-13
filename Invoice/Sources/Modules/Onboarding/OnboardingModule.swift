import SwiftUIExt

struct OnboardingModule: Module {

    let router: OnboardingRouter

    func build() -> UIViewController {
        let viewModel = OnboardingViewModel(
            router: router
        )
        let view = OnboardingView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
