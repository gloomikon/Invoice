import SwiftUI

class WebPageViewModel {

    private let router: WebPageRouter
    let url: URL
    let title: String

    init(
        router: WebPageRouter,
        url: URL,
        title: String
    ) {
        self.router = router
        self.url = url
        self.title = title
    }

    func close() {
        router.close()
    }
}
