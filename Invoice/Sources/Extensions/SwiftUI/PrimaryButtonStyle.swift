import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.pink, in: .capsule)
            .foregroundStyle(.brown)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {

    static var primary: Self {
        Self()
    }
}
