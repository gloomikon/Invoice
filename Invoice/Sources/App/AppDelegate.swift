import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        AppDelegateEvent.applicationDidFinishLaunching(
            application,
            launchOptions: launchOptions
        )
        .send()

        window = AppWindow()
        window.map {
            AppCoordinator().strongRouter.setRoot(for: $0)
        }

        return true
    }
}
