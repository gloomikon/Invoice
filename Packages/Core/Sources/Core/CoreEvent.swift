import EventKit

enum CoreEvent: Event {
    case permissionAsked(granted: Bool)
    case notificationsAsked(granted: Bool)
}
