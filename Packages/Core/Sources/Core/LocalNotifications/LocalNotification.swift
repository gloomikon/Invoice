public protocol LocalNotificationType {
    static var identifier: String { get }
}

public protocol LocalNotification {
    var title: String { get }
    var message: String? { get }
    static var type: LocalNotificationType.Type { get }
    var trigger: LocalNotificationTriggerProtocol { get }
}

public extension LocalNotification {
    var type: LocalNotificationType.Type {
        Self.type
    }
}
