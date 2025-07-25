import Foundation

struct WorkItem: Identifiable, Equatable {

    enum UnitType: String, Equatable {
        case item
        case hour
        case day
    }

    let id: UUID
    let name: String
    let description: String?

    let price: Double
    let quantity: Int
    let unitType: UnitType
    let discount: DiscountType?

    let taxable: Bool

    // TODO: - Fix
    var cdWorkItem: CD_WorkItem?

    var amount: Double {
        let totalPrice = price * Double(quantity)
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

extension WorkItem {

    init(_ item: CD_WorkItem) {
        self.id = item.id
        self.name = item.name
        self.description = item.itemDescription
        self.price = item.price
        self.quantity = Int(item.quantity)
        self.unitType = item.unitType
        self.discount = item.discount
        self.taxable = item.taxable

        self.cdWorkItem = item
    }
}
