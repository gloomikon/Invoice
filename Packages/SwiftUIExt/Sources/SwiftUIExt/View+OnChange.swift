import SwiftUI

public extension View {

    @ViewBuilder
    func onChangeOf<V: Equatable>(
        _ value: V,
        action: @escaping (_ previous: V, _ current: V) -> Void
    ) -> some View {
        if #available(iOS 17, *) {
            onChange(of: value, action)
        } else {
            onChange(of: value) { [value] newValue in
                action(value, newValue)
            }
        }
    }
}
