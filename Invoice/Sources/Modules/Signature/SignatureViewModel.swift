import Combine
import Depin
import UIKit

class SignatureViewModel: ObservableObject {

    @Injected private var appStorage: AppStorage

    func close() {

    }

    func createSignatureTapped(signature: UIImage?) {
        appStorage.userSignature = signature
    }
}
