import SwiftUI

extension EnvironmentValues {
    @Entry var paywallLayout: any PaywallLayout = IgnoringHeaderLayout()
}

extension View {

    func paywallLayout(_ layout: any PaywallLayout) -> some View {
        environment(\.paywallLayout, layout)
    }
}
