import SwiftUI

struct EmptyButtonStyle: PrimitiveButtonStyle {

    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onTapGesture {
                configuration.trigger()
            }
    }
}

extension PrimitiveButtonStyle where Self == EmptyButtonStyle {

    /// A button style that doesn't style or decorate its content
    static var empty: EmptyButtonStyle { EmptyButtonStyle() }
}
