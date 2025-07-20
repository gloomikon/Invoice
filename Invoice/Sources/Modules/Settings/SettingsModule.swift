import SwiftUIExt

struct SettingsModule: Module {

    let router: SettingsRouter

    func build() -> UIViewController {
        let viewModel = SettingsViewModel(
            router: router
        )
        let view = SettingsView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
