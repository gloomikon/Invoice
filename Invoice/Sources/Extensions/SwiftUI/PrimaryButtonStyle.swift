import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.poppins(size: 16, weight: .semiBold))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.linkedIn, in: .capsule)
            .foregroundStyle(.white)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {

    static var primary: Self {
        Self()
    }
}
