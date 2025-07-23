import Combine
import Depin
import UIKit

@MainActor
class EditBusinessViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var databaseManager: DatabaseManager

    private let router: EditBusinessRouter
    private let business: CD_Business

    // MARK: - Public properties

    @Published var name: String
    @Published var contactName: String
    @Published var contactEmail: String
    @Published var contactPhone: String
    @Published var contactAddress: String
    @Published var signature: UIImage?

    init(
        router: EditBusinessRouter,
        business: CD_Business
    ) {
        self.router = router
        self.business = business

        self.name = business.name
        self.contactName = business.contactName ?? ""
        self.contactEmail = business.contactEmail?.email ?? ""
        self.contactPhone = business.contactPhone ?? ""
        self.contactAddress = business.contactAddress ?? ""
        self.signature = business.signatureFileName.flatMap {
            guard
                let data = FileManager.default.photoJPEGData(withName: $0),
                    let image = UIImage(data: data) else {
                return nil
            }

            return image
        }
    }

    func close() {
        router.closeEditBusiness()
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

        databaseManager.updateBusiness(
            business,
            name: name,
            contactName: contactName.nilIfEmpty,
            contactEmail: Email(contactEmail),
            contactPhone: contactPhone.nilIfEmpty,
            contactAddress: contactAddress.nilIfEmpty,
            signatureFileName: signatureFileName
        )
        router.closeEditBusiness()
    }

    func delete() {
        databaseManager.deleteBusiness(with: business.id)
        router.closeEditBusiness()
    }
}
