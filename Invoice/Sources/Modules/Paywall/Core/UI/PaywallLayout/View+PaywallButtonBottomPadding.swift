import SwiftUI

extension EnvironmentValues {
    @Entry var paywallButtonBottomPadding: CGFloat = 67
}

extension View {

    func paywallButtonBottomPadding(_ padding: CGFloat) -> some View {
        environment(\.paywallButtonBottomPadding, padding)
    }
}
