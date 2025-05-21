import Depin

class StartupService {

    @Injected private var purchaseManager: PurchaseManager

    func start() async {
        purchaseManager.configure()

        await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.purchaseManager.fetchSubscriptionStatus()
            }
            group.addTask {
                await self.purchaseManager.fetchOfferings()
            }
        }
    }
}
