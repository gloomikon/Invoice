import Depin

class PaywallAssembly: Assembly {

    func assemble(container: Container) {

        container.register(InAppPaywallProvider.self) {
            InAppPaywallProvider()
        }

        container.register(PurchaseManager.self) {
            PurchaseManager()
        }
        .inObjectScope(.container)
    }
}
