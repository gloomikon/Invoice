import Foundation

struct InvoiceInput {

    let id: String
    let number: String

    let issuedDate: Date
    let dueDate: Date

    let issuer: Party
    let recipient: Party

    let workItems: [WorkItem]
    let currency: Currency
    let discount: DiscountType?
    let tax: TaxType?

    let paymentMethods: [PaymentMethod]
    let signature: ImageResource?
    let notes: String?
}

// MARK: - InvoiceInput + Internal Types

extension InvoiceInput {

    enum DiscountType {
        case percentage(amount: Double)
        case fixed(amount: Double)
    }

    enum TaxType {
        case inclusive(amount: Double)
        case exclusive(amount: Double)
    }

    enum PaymentMethod {
        case bankTransfer(
            accountHolderName: String,
            bankName: String,
            routingNumber: String,
            accountNumber: String
        )
        case payPal(
            link: String?,
            email: String?
        )
        case check(
            payeeName: String,
            mailingAddress: String,
            instructions: String?
        )
    }

    struct Party {
        let name: String
        let address: String
        let phoneNumber: String
        let email: String?
        let taxId: String? // Optional tax or VAT identifier
    }

    struct Currency {
        let amount: Double
        let code: String
        let symbol: String
    }

    struct WorkItem {

        enum UnitType {
            case hour
            case day
        }

        let name: String
        let description: String

        let price: Double
        let quantity: Double
        let unitType: UnitType?
        let discount: DiscountType?

        let taxable: Bool
        let saveToCatalog: Bool
    }
}
