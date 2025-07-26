import Combine
import Depin
import UIKit

@MainActor
class CreateWorkItemViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var databaseManager: DatabaseManager

    enum Discount: Equatable {
        case percentage
        case fixed

        func discountType(_ value: Double) -> DiscountType {
            switch self {
            case .percentage:
                .percentage(amount: value)
            case .fixed:
                .fixed(amount: value)
            }
        }
    }

    @Published var name = ""
    @Published var description = ""
    @Published var price: Double?
    @Published var quantity: Int? = 1
    @Published var unitType: WorkItem.UnitType?
    @Published var hasDiscount = false
    @Published var discount: Double?
    @Published var discountType: Discount = .percentage
    @Published var taxable = false

    var totalDiscount: Double {
        guard hasDiscount, let discount else { return 0 }
        let quantity = quantity ?? 1
        let price = price ?? 0

        return switch discountType {
        case .percentage:
            price * Double(quantity) * (discount / 100)
        case .fixed:
            discount
        }
    }

    var totalPrice: Double {
        let quantity = quantity ?? 1
        let basePrice = (price ?? 0) * Double(quantity)
        return basePrice - totalDiscount
    }

    private let router: CreateWorkItemRouter

    init(router: CreateWorkItemRouter) {
        self.router = router
    }

    func close() {
        router.closeCreateWorkItem()
    }

    func save() {
        let discount: DiscountType? = if hasDiscount {
            discountType.discountType(discount ?? 0)
        } else {
            nil
        }
        databaseManager.createWorkItem(
            name: name,
            description: description.nilIfEmpty,
            price: price ?? 0,
            quantity: quantity ?? 1,
            unitType: unitType,
            discount: discount,
            taxable: taxable
        )
        router.closeCreateWorkItem()
    }
}
