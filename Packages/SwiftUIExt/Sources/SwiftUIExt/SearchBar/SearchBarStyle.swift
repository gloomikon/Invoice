import UIKit

public protocol SearchBarStyle {

    func configure(_ searchBar: UISearchBar)

    var delegate: UISearchBarDelegate? { get }
}
