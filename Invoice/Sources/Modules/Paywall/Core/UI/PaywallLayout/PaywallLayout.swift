import SwiftUI

protocol PaywallLayout {
    associatedtype Body: View

    typealias Content = PaywallLayoutContent

    @ViewBuilder func body(
        content: Content
    ) -> Body
}

struct PaywallLayoutContent {
    let header: AnyView
    let content: AnyView
    let footer: AnyView
}
