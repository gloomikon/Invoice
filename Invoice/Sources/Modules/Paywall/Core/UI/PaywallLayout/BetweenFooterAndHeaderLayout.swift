import SwiftUI

struct BetweenFooterAndHeaderLayout: PaywallLayout {

    func body(content: Content) -> some View {
        VStack(spacing: .zero) {
            content.header
            content.content
            content.footer
                .border(.yellow)
        }
    }
}

extension PaywallLayout where Self == BetweenFooterAndHeaderLayout {

    static var betweenFooterAndHeader: Self {
        Self()
    }
}
