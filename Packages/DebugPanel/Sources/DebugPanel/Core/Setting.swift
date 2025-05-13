import SwiftUI

public protocol Setting {

    var id: UUID { get }
    var icon: Image? { get }
    var backgroundColor: Color? { get }
    var tintColor: Color? { get }

    func isSearchable(with text: String) -> Bool
}

public protocol DisplayableSetting: Setting, View {

    var icon: Image? { get set }
    var backgroundColor: Color? { get set }
    var tintColor: Color? { get set }
}

public extension DisplayableSetting {

    /// Changes the background color of the icon of setting
    /// - Parameter color: New background color
    /// - Returns: New instance with updated background color
     func backgroundColor(_ color: Color) -> Self {
        var copy = self
        copy.backgroundColor = color
        return copy
    }

    /// Changes the tint color of the icon of setting
    /// - Parameter color: New tint color
    /// - Returns: New instance with updated tint color
    func tintColor(_ color: Color) -> Self {
        var copy = self
        copy.tintColor = color
        return copy
    }

    /// Changes the icon of setting
    /// - Parameter color: New icon
    /// - Returns: New instance with updated icon
    func icon(_ icon: Image) -> Self {
        var copy = self
        copy.icon = icon
        return copy
    }
}

@resultBuilder public enum SettingBuilder {

    public static func buildPartialBlock(first: Setting) -> [Setting] {
        [first]
    }

    public static func buildPartialBlock(first: [Setting]) -> [Setting] {
        first
    }

    public static func buildPartialBlock(accumulated: [Setting], next: Setting) -> [Setting] {
        accumulated + CollectionOfOne(next)
    }

    public static func buildPartialBlock(accumulated: [Setting], next: [Setting]) -> [Setting] {
        accumulated + next
    }

//    public static func buildBlock(_ components: Setting...) -> [Setting] {
//        components
//    }

//    public static func buildArray(_ components: [[Setting]]) -> [Setting] {
//        components.flatMap { $0 }
//    }

    public static func buildOptional(_ component: [Setting]?) -> [Setting] {
        if let component {
            component
        } else {
            []
        }
    }

    public static func buildEither(first component: [Setting]) -> [Setting] {
        component
    }

    public static func buildEither(second component: [Setting]) -> [Setting] {
        component
    }
}
