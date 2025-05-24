import FirebaseCrashlytics
import UIKit

class CrashlyticsClient: AnalyticsClient {

    private let deviceID: String

    init(deviceID: String) {
        self.deviceID = deviceID
    }

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        setUserID(deviceID)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func application(
        _: UIApplication,
        continue _: NSUserActivity,
        restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void
    ) {

    }

    func application(
        _ app: UIApplication,
        open incomingURL: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) {

    }

    func setUserID(_ id: String) {
        Crashlytics.crashlytics().setUserID(id)
    }

    func sendEvent(name: String, parameters: [String: Any]?) {
        let parameters = parameters ?? [:]
        Crashlytics.crashlytics().log(
            format: "%@ %@",
            arguments: getVaList([name, "\(parameters)"])
        )
    }

    func increment(_ name: String, value: Int) {

    }

    func set(_ name: String, with value: Int) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: name)
    }

    func set(_ name: String, with value: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: name)
    }
}
