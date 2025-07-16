import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold)) // TODO: - Fix font
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
