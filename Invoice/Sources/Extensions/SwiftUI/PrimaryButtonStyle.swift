import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.poppins(size: 16, weight: .semiBold))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.linkedIn, in: .capsule)
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {

    static var primary: Self {
        Self()
    }
}
