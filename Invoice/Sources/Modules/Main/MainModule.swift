import Depin
import SwiftUIExt

struct MainModule: Module {

    let router: MainRouter

    func build() -> UIViewController {
        @Injected var database: DatabaseManager
        let viewModel = MainViewModel(
            router: router
        )
        let view = MainView(
            viewModel: viewModel,
            databaseManager: database
        )
        let viewController = HostingController(rootView: view)
        return viewController
    }
}
