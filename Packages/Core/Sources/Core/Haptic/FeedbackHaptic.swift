import UIKit

public protocol FeedbackHaptic {

    var type: UINotificationFeedbackGenerator.FeedbackType { get }
}

public extension FeedbackHaptic {

    func fire() {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}

public struct SuccessHaptic: FeedbackHaptic {

    public let type: UINotificationFeedbackGenerator.FeedbackType = .success
}

public extension FeedbackHaptic where Self == SuccessHaptic {

    static var success: Self {
        Self()
    }
}

public struct WarningHaptic: FeedbackHaptic {

    public let type: UINotificationFeedbackGenerator.FeedbackType = .warning
}

public extension FeedbackHaptic where Self == WarningHaptic {

    static var warning: Self {
        Self()
    }
}

public struct ErrorHaptic: FeedbackHaptic {

    public let type: UINotificationFeedbackGenerator.FeedbackType = .error
}

public extension FeedbackHaptic where Self == ErrorHaptic {

    static var error: Self {
        Self()
    }
}
