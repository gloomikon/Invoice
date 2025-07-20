import SwiftUI

struct IconButtonStyle: ButtonStyle {

    let scaleAnchor: UnitPoint

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1, anchor: scaleAnchor)
            .animation(.bouncy, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == IconButtonStyle {

    static func icon(scaleAnchor: UnitPoint) -> Self {
        Self(scaleAnchor: scaleAnchor)
    }

    static var icon: Self {
        Self(scaleAnchor: .center)
    }
}
