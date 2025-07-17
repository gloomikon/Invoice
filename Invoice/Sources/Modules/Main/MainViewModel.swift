import Combine
import Depin

class MainViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var appStorage: AppStorage

    private let router: MainRouter

    init(router: MainRouter) {
        self.router = router
        appStorage.didSeeMain = true
    }
}
