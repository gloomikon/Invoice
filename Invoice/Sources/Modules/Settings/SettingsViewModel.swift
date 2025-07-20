import Combine
import Depin

@MainActor
class SettingsViewModel: ObservableObject {

    // MARK: - Injected properties

    @Injected private var appStorage: AppStorage

    private let router: SettingsRouter

    // MARK: - Public properties

    var udid: String {
        appStorage.deviceUDID
    }

    init(router: SettingsRouter) {
        self.router = router
    }

    func close() {
        router.close()
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

    func openIssuersList() {
        router.openIssuersList()
    }

    func openItemsList() {
        router.openItemsList()
    }
}
