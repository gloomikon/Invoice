import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) private var enabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.poppins(size: 16, weight: .semiBold))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.linkedIn.opacity(enabled ? 1 : 0.5), in: .capsule)
            .foregroundStyle(.white.opacity(enabled ? 1 : 0.5))
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.2), value: enabled)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {

    static var primary: Self {
        Self()
    }
}
