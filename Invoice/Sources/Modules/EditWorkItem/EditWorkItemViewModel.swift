import Combine
import Depin
import UIKit

@MainActor
class EditWorkItemViewModel: ObservableObject {

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

    @Published var name: String
    @Published var description: String
    @Published var price: Double?
    @Published var quantity: Int?
    @Published var unitType: WorkItem.UnitType?
    @Published var hasDiscount: Bool
    @Published var discount: Double?
    @Published var discountType: Discount
    @Published var taxable: Bool

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

    private let router: EditWorkItemRouter
    private let workItem: CD_WorkItem

    init(router: EditWorkItemRouter, workItem: CD_WorkItem) {
        self.router = router
        self.name = workItem.name
        self.description = workItem.itemDescription ?? ""
        self.price = workItem.price
        self.quantity = Int(workItem.quantity)
        self.unitType = workItem.unitType
        self.hasDiscount = workItem.discount != nil
        self.discount = workItem.discount.map { type in
            switch type {
            case let .fixed(amount), let .percentage(amount):
                amount
            }
        }
        self.discountType = workItem.discount.map { type in
            switch type {
            case .fixed:
                Discount.fixed
            case .percentage:
                Discount.percentage
            }
        } ?? .percentage

        self.taxable = workItem.taxable

        self.workItem = workItem
    }

    func close() {
        router.closeEditWorkItem()
    }

    func save() {
        let discount: DiscountType? = if hasDiscount {
            discountType.discountType(discount ?? 0)
        } else {
            nil
        }
        databaseManager.updateWorkItem(
            workItem,
            name: name,
            description: description.nilIfEmpty,
            price: price ?? 0,
            quantity: quantity ?? 1,
            unitType: unitType,
            discount: discount,
            taxable: taxable
        )
        router.closeEditWorkItem()
    }

    func delete() {
        databaseManager.deleteWorkItem(with: workItem.id)
        router.closeEditWorkItem()
    }
}
