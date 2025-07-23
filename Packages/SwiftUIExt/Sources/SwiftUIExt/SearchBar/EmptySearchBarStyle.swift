import UIKit

public struct EmptySearchBarStyle: SearchBarStyle {

    public func configure(_ searchBar: UISearchBar) {

    }

    public var delegate: UISearchBarDelegate? {
        nil
    }
}

public extension SearchBarStyle where Self == EmptySearchBarStyle {

    /// SearchBarStyle that does not do any appearance modification
    static var empty: Self {
        Self()
    }
}
