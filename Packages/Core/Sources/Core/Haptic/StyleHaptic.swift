import UIKit

public protocol StyleHaptic {
    var style: UIImpactFeedbackGenerator.FeedbackStyle { get }
}

public extension StyleHaptic {

    func fire() {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

public struct LightHaptic: StyleHaptic {

    public let style: UIImpactFeedbackGenerator.FeedbackStyle = .light
}

public extension StyleHaptic where Self == LightHaptic {

    static var light: Self {
        Self()
    }
}

public struct SoftHaptic: StyleHaptic {

    public let style: UIImpactFeedbackGenerator.FeedbackStyle = .soft
}

public extension StyleHaptic where Self == SoftHaptic {

    static var soft: Self {
        Self()
    }
}

public struct MediumHaptic: StyleHaptic {

    public let style: UIImpactFeedbackGenerator.FeedbackStyle = .medium
}

public extension StyleHaptic where Self == MediumHaptic {

    static var medium: Self {
        Self()
    }
}

public struct HeavyHaptic: StyleHaptic {

    public let style: UIImpactFeedbackGenerator.FeedbackStyle = .heavy
}

public extension StyleHaptic where Self == HeavyHaptic {

    static var heavy: Self {
        Self()
    }
}
