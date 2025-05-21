import Depin

class AppAssembly: Assembly {

    func assemble(container: Container) {

        container.register(StartupService.self) {
            StartupService()
        }

        container.register(AppStorage.self) {
            AppStorage()
        }
    }
}
