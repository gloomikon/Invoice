import SwiftUI

struct IgnoringFooterAndHeaderLayout: PaywallLayout {

    func body(content: Content) -> some View {
        content.content
            .overlay(alignment: .top) {
                content.header
            }
            .overlay(alignment: .bottom) {
                content.footer
            }
    }
}

extension PaywallLayout where Self == IgnoringFooterAndHeaderLayout {

    static var ignoringFooterAndHeader: Self {
        Self()
    }
}
