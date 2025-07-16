import CombineExt
import Core
import DebugPanel
import Depin
import FoundationExt
import UIKit

@MainActor
class SplashViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var startupService: StartupService
    @Injected private var networkStatusService: NetworkStatusService
    private let router: SplashRouter

    @Published var showNoInternetConnection = false

    private var internetIsActive = true

    // MARK: - Private properties

    private var bag = CancelBag()

    init(router: SplashRouter) {
        self.router = router

        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .first()
            .void()
            .sink { [weak self] in
                Task { await self?.start() }
            }
            .store(in: &bag)

        let stream = networkStatusService.statusStream()
        Task { [weak self] in
            for await status in stream {
                guard let self else { return }
                AdvancedLogger.app.log(AdvancedLog(message: "\(status)", issuer: "status"))
                internetIsActive = status.isConnected
            }
        }
    }

    private func start() async {
        await AdjustATTManager.requestAuthorization()

        if internetIsActive {
            await startupService.start()
            openNextScreen()
        } else {
            showNoInternetConnection = true
        }
    }

    private func openNextScreen() {
        SplashStrategy().route(using: router)
    }

    func tryAgain() {
        showNoInternetConnection = false
        Task {
            try? await Task.sleep(for: .seconds(0.5))
            await start()
        }
    }
}
