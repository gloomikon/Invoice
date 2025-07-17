import SwiftUI

public extension AnyTransition {

    static func blur(radius: CGFloat = 5) -> AnyTransition {
        AnyTransition.modifier(
            active: BlurEffectModifier(radius: radius),
            identity: BlurEffectModifier(radius: 0)
        )
    }
}

private struct BlurEffectModifier: ViewModifier {

    let radius: CGFloat

    func body(content: Content) -> some View {
        content.blur(radius: radius)
    }
}
