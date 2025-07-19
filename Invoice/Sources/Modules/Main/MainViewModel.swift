import Combine
import Depin
import Foundation

// TODO: - Remove
struct Invoice {

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
}

class MainViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var appStorage: AppStorage
    @Injected var databaseManager: DatabaseManager

//    let invoices: [Invoice] = [
//        Invoice(
//            id: UUID(),
//            title: "Website redesign",
//            date: Date(),
//            sum: 4500,
//            dueDays: 10,
//            status: .unpaid
//        ),
//        Invoice(
//            id: UUID(),
//            title: "Logo creation",
//            date: Date(),
//            sum: 1600,
//            dueDays: 14,
//            status: .unpaid
//        ),
//        Invoice(
//            id: UUID(),
//            title: "Animation",
//            date: Date(),
//            sum: 4500,
//            dueDays: 17,
//            status: .paid
//        ),
//        Invoice(
//            id: UUID(),
//            title: "gloomikon test",
//            date: Date(),
//            sum: 4500,
//            dueDays: 2,
//            status: .paid
//        )
//    ]

    let invoices: [Invoice] = []

    var total: Double {
        invoices.map(\.sum).reduce(0, +)
    }

    private let router: MainRouter

    init(router: MainRouter) {
        self.router = router
        appStorage.didSeeMain = true
    }
}
