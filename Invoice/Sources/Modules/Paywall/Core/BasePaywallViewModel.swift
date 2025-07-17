import CombineExt
import Depin
import FoundationExt
import RevenueCat

class BasePaywallViewModel: PaywallViewModel {

    // MARK: - Injected properties

    let router: PaywallRouter
    let paywall: Paywall

    @Injected private var purchaseManager: PurchaseManager
    @Injected private var appStorage: AppStorage

    // TODO: - Add cloaking
//    let crossHiddenProvider: CrossHiddenProvider = AppDependencies.shared.crossHiddenProvider
//    let boldPricesProvider: BoldPricesProvider = AppDependencies.shared.boldPricesProvider

    @Published var selectedPackage: Package?
    @Published var packages: [Package] = []

    var bag = CancelBag()

    // MARK: - Public properties

    @Published var buttonTitle = ""
    @Published var crossVisible = true
    @Published var isLoading = false // TODO: - true by default
    @Published var alert: PaywallAlert?

    init(router: PaywallRouter, paywall: Paywall) {
        self.router = router
        self.paywall = paywall

        PaywallEvent.paywallShown(name: paywall.name)
            .send()

        bind()
        fetchPackages()
    }

    private func fetchPackages() {
        Task {
            if let packages = await purchaseManager.packages(for: paywall.offering) {
                onMain {
                    self.packages = packages
                    isLoading = false
                }
            }
        }
    }

    func bind() {
        // TODO: - Add cloaking
//        crossHiddenProvider.crossHiddenPublisher
//            .toggle()
//            .assign(to: &$crossVisible)
    }

    func close() {
        PaywallEvent.paywallClosed(name: paywall.name)
            .send()
        router.openMainScreen()
    }

    func buy() {
        PaywallEvent.paywallCTATapped(name: paywall.name)
            .send()

        guard let selectedPackage else { return }
        isLoading = true

        tryAwait {
            try await purchaseManager.purchase(package: selectedPackage)
            await handleSuccessFullPurchase()
        } onCatch: { error in
            await handlePurchaseError(error)
        }
    }

    @MainActor private func handleSuccessFullPurchase() async {
        alert = .success
    }

    @MainActor private func handlePurchaseError(_ error: Error) async {
        if let error = error as? RevenueCat.ErrorCode {
            if error == .purchaseCancelledError {
                isLoading = false
            } else {
                PaywallEvent.purchaseFailed(code: error.errorCode, userInfo: error.errorUserInfo)
                    .send()

                switch error {
                case .purchaseNotAllowedError:
                    alert = .error(String(localized: "Purchase failed. Purchases are not allowed on this device"))
                case .productAlreadyPurchasedError:
                    alert = .error(String(localized: "Purchase failed. Product is already purchased"))
                case .networkError:
                    alert = .error(String(localized: "Purchase failed. Check your interned connection and try again"))
                case .offlineConnectionError:
                    alert = .error(String(localized: "Purchase failed. Your connection seems to be offline"))
                default:
                    // swiftlint:disable:next line_length
                    alert = .error(String(localized: "Purchase failed. Unknown error occurred. Try again later or contact support"))
                }
            }
        } else if error is PurchaseManagerError {
            alert = .error(String(localized: "Restore failed. There are no products to restore"))
        } else {
            // swiftlint:disable:next line_length
            alert = .error(String(localized: "Purchase failed. Unknown error occurred. Try again later or contact support"))
            PaywallEvent.purchaseFailed(userInfo: [NSDebugDescriptionErrorKey: error.localizedDescription])
                .send()
        }
    }

    func restore() {
        isLoading = true

        tryAwait {
            try await purchaseManager.restore()
            await handleSuccessFullPurchase()
        } onCatch: { error in
            await handlePurchaseError(error)
        }
    }

    func openTermsOfUse() {
        PaywallEvent.termsOfUseOpened
            .send()
        router.openTermsOfService()
    }

    func openPrivacyPolicy() {
        PaywallEvent.privacyPolicyOpened
            .send()
        router.openPrivacyPolicy()
    }
}
