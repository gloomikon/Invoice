import Depin
import SwiftUIExt

struct MainModule: Module {

    let router: MainRouter

    func build() -> UIViewController {
        let viewModel = MainViewModel(router: router)
        let view = MainView(viewModel: viewModel)
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
