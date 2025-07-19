import Combine
import Depin
import Foundation

// TODO: - Remove
struct Invoice: Identifiable {

    enum PaidStatus {
        case unpaid
        case paid
    }
    let id: UUID
    let title: String
    let date: Date
    let sum: Double
    let dueDays: Int
    let status: PaidStatus
    let currency: Currency
}

class MainViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var appStorage: AppStorage
    @Injected var databaseManager: DatabaseManager

    @Published var paidStatus: Invoice.PaidStatus?

    let allInvoices: [Invoice] = [
        Invoice(
            id: UUID(),
            title: "Website redesign",
            date: Date(),
            sum: 4500,
            dueDays: 10,
            status: .unpaid,
            currency: .usd
        ),
        Invoice(
            id: UUID(),
            title: "Logo creation",
            date: Date(),
            sum: 1600,
            dueDays: 14,
            status: .unpaid,
            currency: .eur
        ),
        Invoice(
            id: UUID(),
            title: "Animation",
            date: Date(),
            sum: 4500,
            dueDays: 17,
            status: .unpaid,
            currency: .pln
        ),
        Invoice(
            id: UUID(),
            title: "gloomikon test",
            date: Date(),
            sum: 4500,
            dueDays: 2,
            status: .unpaid,
            currency: .uah
        )
    ]

    var invoices: [Invoice] {
        if let paidStatus {
            allInvoices.filter { $0.status == paidStatus }
        } else {
            allInvoices
        }
    }

    var total: String {
        invoices.totalBreakdown
    }

    private let router: MainRouter

    init(router: MainRouter) {
        self.router = router
        appStorage.didSeeMain = true
    }
}

private extension Array where Element == Invoice {
    var totalBreakdown: String {
        let grouped = Dictionary(grouping: self) { $0.currency }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current

        let lines = grouped.map { currency, invoices in
            let total = invoices.reduce(0) { $0 + $1.sum }
            formatter.currencySymbol = currency.symbol
            return formatter.string(from: NSNumber(value: total)) ?? "\(Int(total))\(currency.symbol)"
        }

        return lines.joined(separator: ", ")
    }
}
