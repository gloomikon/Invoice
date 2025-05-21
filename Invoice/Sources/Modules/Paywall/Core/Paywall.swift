protocol Paywall: Module {
    /// Analytics name of the paywall
    static var name: String { get }

    /// RevenueCat's offering for the given paywall
    static var offering: String { get }

    init(router: PaywallRouter)
}

extension Paywall {

    var name: String {
        Self.name
    }

    var offering: String {
        Self.offering
    }
}
