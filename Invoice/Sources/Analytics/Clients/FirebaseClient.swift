import FirebaseAnalytics
import FirebaseCore

class FirebaseClient: AnalyticsClient {

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        FirebaseApp.configure()
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

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func sendEvent(name: String, parameters: [String: Any]? = nil) {

    }

    func setUserID(_ id: String) {

    }

    func increment(_ name: String, value: Int) {

    }

    func set(_ name: String, with value: Int) {

    }

    func set(_ name: String, with value: String) {

    }
}
