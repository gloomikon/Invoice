import SwiftUI

struct IgnoringHeaderLayout: PaywallLayout {

    func body(content: Content) -> some View {
        VStack(spacing: .zero) {
            content.content
            content.footer
        }
        .overlay(alignment: .top) {
            content.header
        }
    }
}

extension PaywallLayout where Self == IgnoringHeaderLayout {

    static var `default`: Self {
        .ignoringHeader
    }

    static var ignoringHeader: Self {
        Self()
    }
}
