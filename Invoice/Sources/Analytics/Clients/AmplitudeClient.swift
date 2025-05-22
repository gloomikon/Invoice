import Amplitude
import UIKit

class AmplitudeClient: AnalyticsClient {

    private let amplitude = Amplitude.instance()

    private let apiKey: String
    private let deviceID: String

    init(apiKey: String, deviceID: String) {
        self.apiKey = apiKey
        self.deviceID = deviceID
    }

    private func setUserID(_ id: String) {
        amplitude.setUserId(id)
    }

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        amplitude.eventUploadPeriodSeconds = 5

        amplitude.initializeApiKey(apiKey)

        setUserID(deviceID)
        amplitude.defaultTracking.sessions = true

        sendCohortUserProperty()
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

    func sendEvent(name: String, parameters: [String: Any]? = nil) {
        amplitude.logEvent(name, withEventProperties: parameters)
    }

    func increment(_ name: String, value: Int) {
        guard let identify = AMPIdentify().add(name, value: NSNumber(value: value)) else {
            return
        }
        amplitude.identify(identify)
    }

    func set(_ name: String, with value: Int) {
        guard let identify = AMPIdentify().set(name, value: NSNumber(value: value)) else {
            return
        }
        amplitude.identify(identify)
    }

    func set(_ name: String, with value: String) {
        guard let identify = AMPIdentify().set(name, value: value as NSString) else {
            return
        }
        amplitude.identify(identify)
    }

    private func sendCohortUserProperty() {
        let identify = AMPIdentify()
        let date = Date()
        let calendar = Calendar.current

        let day = calendar.ordinality(of: .day, in: .year, for: date)
        let week = calendar.ordinality(of: .weekOfYear, in: .year, for: date)
        let month = calendar.ordinality(of: .month, in: .year, for: date)
        let year = calendar.component(.year, from: date)

        let properties: [String: Int] = [
            "cohort_day": day ?? 0,
            "cohort_week": week ?? 0,
            "cohort_month": month ?? 0,
            "cohort_year": year
        ]
        properties.forEach {
            identify.setOnce($0.key, value: NSNumber(value: $0.value))
        }

        amplitude.identify(identify)
    }
}
