import SwiftUI

public extension View {

    @ViewBuilder func spacedFont(_ font: UIFont, multiplier: CGFloat = 1.2) -> some View {
        let pointSize = font.pointSize
        let font = Font(font)
        let spacing = (multiplier * pointSize - pointSize) / 2

        self
            .font(font)
            .lineSpacing(spacing)
    }
}
