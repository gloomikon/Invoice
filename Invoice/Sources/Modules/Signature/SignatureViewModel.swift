import Combine
import Depin
import UIKit

class SignatureViewModel: ObservableObject {

    @Injected private var appStorage: AppStorage

    private let router: SignatureRouter

    init(router: SignatureRouter) {
        self.router = router
    }

    func close() {
        router.close()
    }

    func createSignatureTapped(signature: UIImage?) {
        appStorage.userSignature = signature
        router.close()
    }
}
