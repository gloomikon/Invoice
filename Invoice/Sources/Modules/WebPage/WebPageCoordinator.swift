import XCoordinator

enum WebPageRoute: Route {
    case webPage(url: URL, title: String)
    case pop
}

class WebPageCoordinator: NavigationCoordinator<WebPageRoute> {

    init(
        rootViewController: UINavigationController,
        url: URL,
        title: String
    ) {
        super.init(rootViewController: rootViewController)
        trigger(.webPage(url: url, title: title))
    }

    override func prepareTransition(for route: WebPageRoute) -> NavigationTransition {
        switch route {

        case let .webPage(url, title):
            let module = WebPageModule(
                router: self,
                url: url,
                title: title
            )
            return .push(module)

        case .pop:
            return .pop()
        }
    }
}

extension WebPageCoordinator: WebPageRouter {

    func close() {
        trigger(.pop)
    }
}
