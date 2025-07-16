import Depin
import FoundationExt

class AppAssembly: Assembly {

    func assemble(container: Container) {

        container.register(StartupService.self) {
            StartupService()
        }

        container.register(AppStorage.self) {
            AppStorage()
        }

        container.register(RemoteConfigService.self) {
            RemoteConfigService(provider: FirebaseRemoteConfigProvider())
        }
        .inObjectScope(.container)

        container.register(CoreDataStack.self) {
            CoreDataStack()
        }
        .inObjectScope(.container)

        container.register(DatabaseManager.self) {
            DatabaseManager()
        }
        .inObjectScope(.container)

        container.register(NetworkStatusService.self) {
            NetworkStatusService()
        }
        .inObjectScope(.container)
    }
}
