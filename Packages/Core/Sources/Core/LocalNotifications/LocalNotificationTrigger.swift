import Foundation
import UserNotifications

public protocol LocalNotificationTriggerProtocol {
    var trigger: UNNotificationTrigger { get }
}

public struct CalendarLocalNotificationTrigger: LocalNotificationTriggerProtocol {

    let dateMatching: DateComponents
    let repeats: Bool

    public var trigger: UNNotificationTrigger {
        UNCalendarNotificationTrigger(
            dateMatching: dateMatching,
            repeats: repeats
        )
    }
}

public extension LocalNotificationTriggerProtocol where Self == CalendarLocalNotificationTrigger {

    static func calendar(
        dateMatching: DateComponents,
        repeats: Bool
    ) -> Self {
        Self(dateMatching: dateMatching, repeats: repeats)
    }
}

public struct IntervalLocalNotificationTrigger: LocalNotificationTriggerProtocol {

    let timeInterval: TimeInterval
    let repeats: Bool

    public var trigger: UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: repeats
        )
    }
}

public extension LocalNotificationTriggerProtocol where Self == IntervalLocalNotificationTrigger {
    static func interval(
        timeInterval: TimeInterval,
        repeats: Bool
    ) -> Self {
        Self(
            timeInterval: timeInterval,
            repeats: repeats
        )
    }
}
