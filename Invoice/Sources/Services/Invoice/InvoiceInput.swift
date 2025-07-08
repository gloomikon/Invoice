import Foundation

struct InvoiceInput {

    let id: String
    let number: String

    let issuedDate: Date
    let dueDate: Date?

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
        let code: String
        let symbol: String
    }

    struct WorkItem {

        enum UnitType {
            case item
            case hour
            case day
        }

        let name: String
        let description: String?

        let price: Double
        let quantity: Double
        let unitType: UnitType
        let discount: DiscountType?

        let taxable: Bool
        let saveToCatalog: Bool

        var amount: Double {
            let totalPrice = price * quantity
            let itemDiscount: Double
            if let discount = discount {
                switch discount {
                case .fixed(let value):
                    itemDiscount = value
                case .percentage(let value):
                    itemDiscount = totalPrice * (value / 100)
                }
            } else {
                itemDiscount = 0
            }
            return totalPrice - itemDiscount
        }
    }
}

// MARK: - Totals

extension InvoiceInput {

    struct Totals {
        var subtotal: Double = 0
        var discountValue: Double = 0
        var taxValue: Double = 0
        var total: Double = 0
    }

    var totals: Totals {
        var result = Totals()

        workItems.forEach { result.subtotal += $0.amount }

        // global discount
        if let discount {
            switch discount {
            case .fixed(let value):
                result.discountValue += value
            case .percentage(let value):
                result.discountValue += result.subtotal * (value / 100)
            }
        }

        // tax
        if let tax {
            var taxableAmount = workItems
                .filter { $0.taxable }
                .map { $0.amount }
                .reduce(0.0, +)

            if let discount {
                switch discount {
                case .fixed(let value):
                    taxableAmount -= value
                case .percentage(let value):
                    taxableAmount -= (result.subtotal * (value / 100))
                }
            }

            switch tax {
            case let .inclusive(value):
                let taxRate = value / 100
                result.taxValue = taxableAmount * (taxRate / (1 + taxRate))
                result.total = result.subtotal - result.discountValue
            case let .exclusive(value):
                let exclusiveTaxValue = taxableAmount * (value / 100)
                result.taxValue = exclusiveTaxValue
                result.total = result.subtotal - result.discountValue + exclusiveTaxValue
            }
        }
        return result
    }
}
