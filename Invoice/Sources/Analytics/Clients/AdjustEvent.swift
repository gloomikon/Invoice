import AdjustSdk
import EventKit

enum AdjustEvent: Event {

    case attribution([AnyHashable: Any])
    case deeplinkReceived(String)
    case gotAdjustID(String)
    case permissionAsked(granted: Bool)
}

// TODO: - Use this for Adjust
enum AdjustATTManager {

    static func requestAuthorization() async {
        let currentStatus = Adjust.appTrackingAuthorizationStatus()

        if currentStatus != 0 {
            return
        }

        let status = await Adjust.requestAppTrackingAuthorization()
        let granted = status == 3
        AdjustEvent.permissionAsked(granted: granted)
            .send()
    }
}

class AdjustEventProcessor: EventProcessor {

    func process(_ event: AdjustEvent) {
        switch event {

        case .attribution(let dictionary):
            let dictionary: [String: String] = dictionary.reduce(into: [:]) { result, pair in
                let key = "\(pair.key)"
                let value = "\(pair.value)"
                result[key] = value
            }
            send("adjust_attribution", with: dictionary)

        case let .deeplinkReceived(url):
            send("adjust_deeplink_received", with: ["url": url])

        case .gotAdjustID:
            break

        case let .permissionAsked(granted):
            send("permission_asked", with: ["granted": granted])
        }
    }
}

// TODO: - Configure for deep linking? https://dev.adjust.com/en/sdk/ios/features/deep-links

class AdjustAnalyticsClient: NSObject, AnalyticsClient {

    private let deviceID: String
    private let appToken: String

    init(deviceID: String, appToken: String) {
        self.deviceID = deviceID
        self.appToken = appToken
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        #if DEBUG
        let environment = ADJEnvironmentSandbox
        #else
        let environment = ADJEnvironmentProduction
        #endif

        let adjustConfig = ADJConfig(
            appToken: appToken,
            environment: environment
        )

        #if DEBUG
        adjustConfig?.logLevel = .verbose
        #else
        adjustConfig?.logLevel = .suppress
        #endif

        adjustConfig?.attConsentWaitingInterval = 30
        adjustConfig?.externalDeviceId = deviceID
        adjustConfig?.delegate = self

        adjustConfig?.enableLinkMe()

        Adjust.initSdk(adjustConfig)

        Adjust.attribution { attribution in
            guard let attribution = attribution?.dictionary() else {
                return
            }
            AdjustEvent.attribution(attribution)
                .send()
        }

        Task {
            if let adjustID = await Adjust.adid() {
                AdjustEvent.gotAdjustID(adjustID)
                    .send()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void
    ) {

    }

    func application(
        _ app: UIApplication,
        open incomingURL: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) {
        guard let deeplink = ADJDeeplink(deeplink: incomingURL) else {
            return
        }
        Adjust.processDeeplink(deeplink)
    }

    func sendEvent(name: String, parameters: [String: Any]?) {

    }

    func increment(_ name: String, value: Int) {

    }

    func set(_ name: String, with value: Int) {

    }

    func set(_ name: String, with value: String) {

    }
}

// MARK: - AdjustDelegate

extension AdjustAnalyticsClient: AdjustDelegate {
    func adjustAttributionChanged(_: ADJAttribution?) {
        Task {
            if let adjustID = await Adjust.adid() {
                AdjustEvent.gotAdjustID(adjustID)
                    .send()
            }
        }
    }

    func adjustDeferredDeeplinkReceived(_ deeplink: URL?) -> Bool {
        if let deeplink {
            AdjustEvent.deeplinkReceived(deeplink.absoluteString)
                .send()
        }

        return false
    }
}
