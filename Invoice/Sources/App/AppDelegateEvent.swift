import EventKit
import UIKit

enum AppDelegateEvent: Event {

    case applicationDidFinishLaunching(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    )

    case applicationDidBecomeActive(_ application: UIApplication)

    case application(
        _ application: UIApplication,
        activity: NSUserActivity,
        restorationHandler: ([UIUserActivityRestoring]?) -> Void
    )

    case applicationOpenIncomingURL(
        _ app: UIApplication,
        openIncomingURL: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    )
}
