import UIKit

protocol AnalyticsClient {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    )

    func applicationDidBecomeActive(_ application: UIApplication)

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    )

    func application(
        _ app: UIApplication,
        open incomingURL: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    )

    func sendEvent(name: String, parameters: [String: Any]?)
    func increment(_ name: String, value: Int)
    func decrement(_ name: String, value: Int)
    func set(_ name: String, with value: Int)
    func set(_ name: String, with value: String)
}

extension AnalyticsClient {
    func decrement(_ name: String, value: Int) {
        increment(name, value: -value)
    }
}

extension [AnalyticsClient] {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        forEach { $0.application(application, didFinishLaunchingWithOptions: launchOptions) }
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) {
        forEach {
            $0.application(application, continue: userActivity, restorationHandler: restorationHandler)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        forEach {
            $0.applicationDidBecomeActive(application)
        }
    }

    func application(
        _ app: UIApplication,
        open incomingURL: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) {
        forEach {
            $0.application(app, open: incomingURL, options: options)
        }
    }

    func sendEvent(name: String, parameters: [String: Any]?) {
        forEach { $0.sendEvent(name: name, parameters: parameters) }
    }

    func increment(_ name: String, value: Int) {
        forEach { $0.increment(name, value: value) }
    }

    func decrement(_ name: String, value: Int) {
        forEach { $0.decrement(name, value: value) }
    }

    func set(_ name: String, with value: Int) {
        forEach { $0.set(name, with: value) }
    }

    func set(_ name: String, with value: String) {
        forEach { $0.set(name, with: value) }
    }
}
