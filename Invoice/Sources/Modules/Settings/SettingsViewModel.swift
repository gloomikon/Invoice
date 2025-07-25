import Combine
import Depin

@MainActor
class SettingsViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var appStorage: AppStorage

    @Published var isPremium = false

    private let router: SettingsRouter

    // MARK: - Public properties

    var udid: String {
        appStorage.deviceUDID
    }

    init(router: SettingsRouter) {
        self.router = router

        bind()
    }

    private func bind() {
        appStorage.$isPremium
            .assign(to: &$isPremium)
    }

    func close() {
        router.close()
    }

    func openPaywall() {
        router.openPaywall()
    }

    func openPrivacyPolicy() {
        router.openPrivacyPolicy()
    }

    func openTermsOfUse() {
        router.openTermsOfUse()
    }

    func restore() {
        // TODO: - todo
    }

    func rateTheApp() {
        FeedbackService.requestReview()
    }

    func openClientsList() {
        router.openClientsList()
    }

    func openBusinessesList() {
        router.openBusinessesList()
    }

    func openItemsList() {
        router.openItemsList()
    }
}
