import Foundation
import UIKit

enum DiscountType: Equatable {
    case percentage(amount: Double)
    case fixed(amount: Double)
}

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
    let signature: UIImage?
    let notes: String?
}

// MARK: - InvoiceInput + Internal Types

extension InvoiceInput {

    enum TaxType {
        case inclusive(amount: Double)
        case exclusive(amount: Double)
    }

    enum PaymentMethod: CaseIterable {

        static var allCases: [Self] {
            [
                .bankTransfer(accountHolderName: "", bankName: "", routingNumber: "", accountNumber: ""),
                .payPal(email: "", link: nil)
            ]
        }

        case bankTransfer(
            accountHolderName: String,
            bankName: String,
            routingNumber: String,
            accountNumber: String
        )
        case payPal(
            email: String,
            link: String?
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
