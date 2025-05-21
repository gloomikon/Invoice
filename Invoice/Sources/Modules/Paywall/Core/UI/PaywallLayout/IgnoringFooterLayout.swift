import SwiftUI

struct IgnoringFooterLayout: PaywallLayout {

    func body(content: Content) -> some View {
        VStack(spacing: .zero) {
            content.header
            content.content
        }
        .overlay(alignment: .bottom) {
            content.footer
        }
    }
}

extension PaywallLayout where Self == IgnoringFooterLayout {

    static var ignoringFooter: Self {
        Self()
    }
}
