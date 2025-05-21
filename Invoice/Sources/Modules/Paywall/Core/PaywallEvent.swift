import EventKit

enum PaywallEvent: Event {
    case paywallShown(name: String)
    case paywallClosed(name: String)
    case paywallCTATapped(name: String)
    case paywallSwitcherTapped(name: String, enabled: Bool)
    case termsOfUseOpened
    case privacyPolicyOpened
    case purchaseFailed(code: Int? = nil, userInfo: [String: Any] = [:])
}

//class PaywallEventProcessor: EventProcessor {
//
//    func process(_ event: PaywallEvent) {
//        switch event {
//
//        case let .paywallShown(name):
//            send("paywall_shown", with: [
//                "name": name
//            ])
//
//        case let .paywallClosed(name):
//            send("paywall_closed", with: [
//                "name": name
//            ])
//
//        case let .paywallCTATapped(name):
//            send("paywall_cta_tapped", with: [
//                "name": name
//            ])
//
//        case let .paywallSwitcherTapped(name, enabled):
//            send("paywall_switcher_tapped", with: [
//                "name": name,
//                "action": enabled.description
//            ])
//
//        case .termsOfUseOpened:
//            send("terms_of_use_opened")
//
//        case .privacyPolicyOpened:
//            send("privacy_policy_opened")
//
//        case let .purchaseFailed(code, userInfo: userInfo):
//            send(
//                "paywall_purchase_failed",
//                with: userInfo.mapValues { "\($0)" }
//                    .addIfPresent(code?.description, for: "code")
//            )
//    }
//}
