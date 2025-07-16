import Depin

@MainActor
struct SplashStrategy {

    @Injected private var appStorage: AppStorage

    func route(using router: SplashRouter) {
        if appStorage.isPremium {
            router.openHome()
        } else if appStorage.didSeePaywall {
            router.openHome()
        } else {
            router.openIntroFromSplash()
        }
    }
}
