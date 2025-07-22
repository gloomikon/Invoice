import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.poppins(size: 16, weight: .semiBold))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundStyle(.linkedIn)
            .overlay {
                Capsule()
                    .stroke(.linkedIn, lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .contentShape(.capsule)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {

    static var secondary: Self {
        Self()
    }
}
