import Depin

class StartupService {

    @Injected private var purchaseManager: PurchaseManager
    @Injected private var remoteConfigService: RemoteConfigService

    func start() async {
        purchaseManager.configure()

        await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                try await self.remoteConfigService.start()
            }
            group.addTask {
                await self.purchaseManager.fetchSubscriptionStatus()
            }
            group.addTask {
                await self.purchaseManager.fetchOfferings()
            }
        }

        remoteConfigService.values(for: Remote.Key.allCases)
    }
}
