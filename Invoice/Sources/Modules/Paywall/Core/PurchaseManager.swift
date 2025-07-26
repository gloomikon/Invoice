import Depin
import EventKit
import FoundationExt
import RevenueCat

private enum Entitlement {
    static let pro = "Pro" // TODO: Fix
}

enum PurchaseManagerError: Error {
    case nothingToRestore
}

class PurchaseManager {

    @Injected private var appStorage: AppStorage

    private var offerings: [String: Offering] = [:]

    private var wasConfigured = false
    private var deferredActions: [() -> Void] = []

    init() {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
    }

    func configure() {
        Purchases.configure(
            withAPIKey: "fix", // TODO: Fix
            appUserID: appStorage.deviceUDID
        )
        Purchases.shared.attribution.enableAdServicesAttributionTokenCollection()
        wasConfigured = true
        Purchases.shared.attribution.setAttributes(
            [
                "$amplitudeUserId": appStorage.deviceUDID
            ]
        )

        for action in deferredActions {
            action()
        }
        collectDeviceIdentifiers()
    }

    private func performIfConfigured(_ action: @escaping () -> Void) {
        if wasConfigured {
            action()
        } else {
            deferredActions.append(action)
        }
    }

    func collectDeviceIdentifiers() {
        Purchases.shared.attribution.collectDeviceIdentifiers()
    }

    func setAdjustID(_ adjustID: String) {
        performIfConfigured {
            Purchases.shared.attribution.setAdjustID(adjustID)
        }
    }

    func setAttribute(key: String, value: String) {
        performIfConfigured {
            Purchases.shared.attribution.setAttributes(
                [key: value]
            )
        }
    }

    @MainActor
    func fetchSubscriptionStatus() async {
        tryAwait {
            let customerInfo = try await Purchases.shared.customerInfo()
            appStorage.setPremium( customerInfo.entitlements[Entitlement.pro]?.isActive == true)
        } onCatch: { _ in
            appStorage.setPremium(false)
        }
    }

    func fetchOfferings() async {
        await tryAsync {
            let offerings  = try await Purchases.shared.offerings()
            self.offerings = offerings.all
        }
    }

    func packages(for offering: Offering) async -> [Package]? {
        await packages(for: offering.identifier)
    }

    func packages(for offeringID: String) async -> [Package]? {
        if offerings.isEmpty {
            await fetchOfferings()
        }
        return offerings[offeringID]?.availablePackages
    }

    func purchase(package: Package) async throws {
        let data = try await Purchases.shared.purchase(package: package)
        if data.userCancelled == true {
            throw RevenueCat.ErrorCode.purchaseCancelledError
        }
        await fetchSubscriptionStatus()
        if data.customerInfo.activeSubscriptions.contains(package.storeProduct.productIdentifier) {
            return
        } else {
            throw RevenueCat.ErrorCode.unknownError
        }
    }

    #if DEBUG
    func debugPurchase(package: Package) async throws {
        try await Task.sleep(for: .seconds(1))
    }
    #endif

    func restore() async throws {
        _ = try await Purchases.shared.restorePurchases()
        await fetchSubscriptionStatus()
        if await appStorage.isPremium {
            return
        } else {
            throw PurchaseManagerError.nothingToRestore
        }
    }
}

extension PurchaseManager: CompositeEventProcessor {

    func process<E: Event>(_ event: E) {
        switch event {
        case let event as AdjustEvent:
            process(event)
        default:
            break
        }
    }

    private func process(_ event: AdjustEvent) {
        switch event {
        case .gotAdjustID(let adjustID):
            performIfConfigured {
                Purchases.shared.attribution.setAdjustID(adjustID)
            }
        default:
            break
        }
    }
}
