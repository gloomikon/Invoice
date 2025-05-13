import Foundation

/// Group represents a collection of settings that relate to the same problem
public struct Group {

    let id: UUID
    let title: String
    let settings: [Setting]
    
    /// Creates new group of settings
    /// - Parameters:
    ///   - title: Title of the group that will be displayed
    ///   - settings: Collection of settings to include in the group
    public init(
        _ title: String,
        @SettingBuilder settings: () -> [Setting]
    ) {
        self.id = UUID()
        self.title = title
        self.settings = settings()
    }

    init(id: UUID, title: String, settings: [Setting]) {
        self.id = id
        self.title = title
        self.settings = settings
    }
}

@resultBuilder public enum GroupBuilder {

    public static func buildPartialBlock(first: Group) -> [Group] {
        [first]
    }

    public static func buildPartialBlock(first: [Group]) -> [Group] {
        first
    }

    public static func buildPartialBlock(accumulated: [Group], next: Group) -> [Group] {
        accumulated + CollectionOfOne(next)
    }

    public static func buildPartialBlock(accumulated: [Group], next: [Group]) -> [Group] {
        accumulated + next
    }

    public static func buildBlock(_ components: Group...) -> [Group] {
        components
    }

    public static func buildArray(_ components: [[Group]]) -> [Group] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [Group]?) -> [Group] {
        if let component {
            component
        } else {
            []
        }
    }
}
