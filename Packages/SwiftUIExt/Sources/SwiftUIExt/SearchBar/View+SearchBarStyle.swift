import SwiftUI

private struct SearchBarStyleKey: EnvironmentKey {

    static var defaultValue: SearchBarStyle = EmptySearchBarStyle()
}

extension EnvironmentValues {

    var searchBarStyle: SearchBarStyle {
        get { self[SearchBarStyleKey.self] }
        set { self[SearchBarStyleKey.self] = newValue }
    }
}

public extension View {

    func searchBarStyle(_ style: SearchBarStyle) -> some View {
        environment(\.searchBarStyle, style)
    }
}
