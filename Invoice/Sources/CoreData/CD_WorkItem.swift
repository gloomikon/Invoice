import CoreData

@objc(CD_WorkItem)
class CD_WorkItem: NSManagedObject, Managed, Identifiable {

    private static let discountEncoder = JSONEncoder()
    private static let discountDecoder = JSONDecoder()

    static var dateCreatedSortDescriptor: NSSortDescriptor {
        NSSortDescriptor(key: #keyPath(CD_WorkItem.dateCreated), ascending: false)
    }

    static var defaultSortDescriptors: [NSSortDescriptor] {
        [dateCreatedSortDescriptor]
    }

    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var itemDescription: String?
    @NSManaged var price: Double
    @NSManaged var quantity: Int32

    private static let unitTypeKey = "unitType"

    @NSManaged private var primitiveUnitType: String

    var unitType: WorkItem.UnitType {
        get {
            willAccessValue(forKey: Self.unitTypeKey)
            let value = WorkItem.UnitType(rawValue: primitiveUnitType) ?? .item
            didAccessValue(forKey: Self.unitTypeKey)
            return value
        }
        set {
            willChangeValue(forKey: Self.unitTypeKey)
            primitiveUnitType = newValue.rawValue
            didChangeValue(forKey: Self.unitTypeKey)
        }
    }

    @NSManaged private var primitiveDiscount: String?
    private static let discountKey = "discount"

    var discount: DiscountType? {
        get {
            willAccessValue(forKey: Self.discountKey)
            let value: DiscountType? =
            if
                let raw = primitiveDiscount,
                let data = raw.data(using: .utf8) {
                try? Self.discountDecoder.decode(DiscountType.self, from: data)
            } else {
                nil
            }
            didAccessValue(forKey: Self.discountKey)
            return value
        }
        set {
            willChangeValue(forKey: Self.discountKey)
            primitiveDiscount =
            if let newValue,
               let data = try? Self.discountEncoder.encode(newValue) {
                String(data: data, encoding: .utf8)
            } else {
                nil
            }
            didChangeValue(forKey: Self.discountKey)
        }
    }

    @NSManaged var taxable: Bool

    @NSManaged var dateCreated: Date
}

extension CD_WorkItem {

    @discardableResult
    static func create(
        in context: NSManagedObjectContext,
        name: String,
        description: String?,
        price: Double,
        quantity: Int,
        unitType: WorkItem.UnitType,
        discount: DiscountType?,
        taxable: Bool
    ) -> Self {
        Self.create(in: context) { item in
            item.id = UUID()
            item.name = name
            item.itemDescription = description
            item.price = price
            item.quantity = Int32(quantity)
            item.unitType = unitType
            item.discount = discount
            item.taxable = taxable
            item.dateCreated = Date()
        }
    }

    func update(
        name: String,
        description: String?,
        price: Double,
        quantity: Int,
        unitType: WorkItem.UnitType,
        discount: DiscountType?,
        taxable: Bool
    ) {
        self.name = name
        self.itemDescription = description
        self.price = price
        self.quantity = Int32(quantity)
        self.unitType = unitType
        self.discount = discount
        self.taxable = taxable
    }
}

extension DiscountType: Codable {

    enum CodingKeys: String, CodingKey {
        case type
        case amount
    }

    enum DiscountTypeIdentifier: String, Codable {
        case percentage
        case fixed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(DiscountTypeIdentifier.self, forKey: .type)
        let amount = try container.decode(Double.self, forKey: .amount)

        switch type {
        case .percentage:
            self = .percentage(amount: amount)
        case .fixed:
            self = .fixed(amount: amount)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .percentage(let amount):
            try container.encode(DiscountTypeIdentifier.percentage, forKey: .type)
            try container.encode(amount, forKey: .amount)
        case .fixed(let amount):
            try container.encode(DiscountTypeIdentifier.fixed, forKey: .type)
            try container.encode(amount, forKey: .amount)
        }
    }
}
