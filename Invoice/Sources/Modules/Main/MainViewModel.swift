import Combine
import Depin

class MainViewModel: ObservableObject {

    // MARK: - Injected properties

    private let router: MainRouter

    init(router: MainRouter) {
        self.router = router
    }
}
