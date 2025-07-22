import Foundation

struct Client: Identifiable, Equatable {

    let id: String
    let name: String
    let email: Email?
    let phone: String?
    let address: String?
    let dateCreated: Date
    let dateModified: Date
    let cdClient: CD_Client

    init(_ client: CD_Client) {
        self.id = client.id
        self.name = client.name
        self.email = client.email
        self.phone = client.phone
        self.address = client.address
        self.dateCreated = client.dateCreated
        self.dateModified = client.dateModified

        self.cdClient = client
    }
}
