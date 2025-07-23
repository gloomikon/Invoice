import Combine
import Depin
import UIKit

@MainActor
class CreateBusinessViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var databaseManager: DatabaseManager

    @Published var name: String = ""
    @Published var contactName: String = ""
    @Published var contactEmail: String = ""
    @Published var contactPhone: String = ""
    @Published var contactAddress: String = ""
    @Published var signature: UIImage?

    private let router: CreateBusinessRouter

    init(router: CreateBusinessRouter) {
        self.router = router
    }

    func close() {
        router.closeCreateBusiness()
    }

    func clearSignature() {
        signature = nil
    }

    func openSignature() {
        router.openSignature { [unowned self] signature in
            self.signature = signature
        }
    }

    func save() {
        let signatureFileName: String?
        if let data = signature?.jpegData(compressionQuality: 1) {
            signatureFileName = try? FileManager.default.savePhotoJPEGData(data, withName: UUID().uuidString)
        } else {
            signatureFileName = nil
        }

        databaseManager.createBusiness(
            name: name,
            contactName: contactName.nilIfEmpty,
            contactEmail: Email(contactEmail),
            contactPhone: contactPhone.nilIfEmpty,
            contactAddress: contactAddress.nilIfEmpty,
            signatureFileName: signatureFileName
        )
        router.closeCreateBusiness()
    }
}
