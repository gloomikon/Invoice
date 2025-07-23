import Foundation

struct Business: Identifiable, Equatable {

    let id: UUID
    let name: String
    let contactName: String?
    let contactEmail: Email?
    let contactPhone: String?
    let contactAddress: String?
    let signatureURLString: String?
    let dateCreated: Date
    let dateModified: Date

    let cdBusiness: CD_Business

    init(_ business: CD_Business) {
        self.id = business.id
        self.name = business.name
        self.contactName = business.contactName
        self.contactEmail = business.contactEmail
        self.contactPhone = business.contactPhone
        self.contactAddress = business.contactAddress
        self.signatureURLString = business.signatureURLString
        self.dateCreated = business.dateCreated
        self.dateModified = business.dateModified

        self.cdBusiness = business
    }
}
