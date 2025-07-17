import SwiftUI

extension View {

    func font(_ font: UIFont) -> some View {
        self.font(Font(font))
    }
}
