public enum HapticPlayer {

    public static func fire(_ haptic: StyleHaptic) {
        haptic.fire()
    }

    public static func fire(_ haptic: FeedbackHaptic) {
        haptic.fire()
    }

    public static func fire(_ haptic: SelectionHaptic) {
        haptic.fire()
    }
}
