import EventKit

class AnalyticsClientCompositor: EventProcessor {

    private let clients: [AnalyticsClient]

    init(clients: [AnalyticsClient]) {
        self.clients = clients
    }

    init(clients: AnalyticsClient...) {
        self.clients = clients
    }

    func process(_ event: AppDelegateEvent) {
        switch event {

        case let .applicationDidFinishLaunching(application, launchOptions):
            clients.application(application, didFinishLaunchingWithOptions: launchOptions)

        case let .application(application, activity, restorationHandler):
            clients.application(application, continue: activity, restorationHandler: restorationHandler)

        case let .applicationDidBecomeActive(application):
            clients.applicationDidBecomeActive(application)

        case let .applicationOpenIncomingURL(app, incomingURL, options):
            clients.application(app, open: incomingURL, options: options)
        }
    }
}
