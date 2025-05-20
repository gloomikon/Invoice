import NotificationCenter

public class NotificationService {

    private var center: UNUserNotificationCenter {
        .current()
    }

    public init() { }

    public func requestAuthorization() async throws {
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .notDetermined else {
            return
        }

        let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])

        CoreEvent.notificationsAsked(granted: granted)
            .send()
    }

    public func registerNotification(for notification: LocalNotification) async throws {
        let request = createNotificationRequest(
            title: notification.title,
            type: notification.type.identifier,
            message: notification.message,
            trigger: notification.trigger.trigger
        )
        try await center.add(request)
    }

    private func registerNotification(
        title: String,
        type: String,
        message: String?,
        trigger: UNNotificationTrigger
    ) async throws {
        let request = createNotificationRequest(
            title: title,
            type: type,
            message: message,
            trigger: trigger
        )
        try await center.add(request)
    }

    private func createNotificationRequest(
        title: String,
        type: String,
        message: String?,
        trigger: UNNotificationTrigger
    ) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.userInfo = ["notificationType": type]
        content.categoryIdentifier = "alarm"
        content.sound = .default
        content.badge = 1
        if let message {
            content.body = message
        }

        return UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
    }

    public func removePendingNotification(for notification: LocalNotification.Type) async {
        let requests = await center.pendingNotificationRequests()
        let idsToRemove = getIDs(from: requests, for: notification.type.identifier)
        center.removePendingNotificationRequests(withIdentifiers: idsToRemove)
    }

    public func removeDeliveredNotification(for notification: LocalNotification.Type) async {
        let notifications = await center.deliveredNotifications()
        let idsToRemove = getIDs(from: notifications, for: notification.type.identifier)
        let badgeCount = notifications.count - idsToRemove.count
        center.removeDeliveredNotifications(withIdentifiers: idsToRemove)
        await MainActor.run {
            UIApplication.shared.applicationIconBadgeNumber = badgeCount
        }
    }

    private func getIDs(from requests: [UNNotificationRequest], for type: String) -> [String] {
        requests
            .filter { request in
                guard let notificationType = request.content.userInfo["notificationType"] as? String else {
                    return false
                }
                return notificationType == type
            }
            .map { request in
                request.identifier
            }
    }

    private func getIDs(from notifications: [UNNotification], for type: String) -> [String] {
        notifications
            .filter { notification in
                guard let notificationType = notification.request.content.userInfo["notificationType"] as? String else {
                    return false
                }
                return notificationType == type
            }
            .map { notification in
                notification.request.identifier
            }
    }
}
