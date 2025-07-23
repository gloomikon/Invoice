import Combine
import Depin
import UIKit

class SignatureViewModel: ObservableObject {

    private let router: SignatureRouter
    let onCreateSignature: (UIImage) -> Void

    init(
        router: SignatureRouter,
        onCreateSignature: @escaping (UIImage) -> Void
    ) {
        self.router = router
        self.onCreateSignature = onCreateSignature
    }

    func close() {
        router.close()
    }

    func createSignatureTapped(signature: UIImage) {
        onCreateSignature(signature)
        router.close()
    }
}
