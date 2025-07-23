import SwiftUI

public struct SearchBar: UIViewRepresentable {

    @Environment(\.searchBarStyle) var searchBarStyle

    let placeholder: String?
    let text: Binding<String>

    public init(_ placeholder: String?, text: Binding<String>) {
        self.text = text
        self.placeholder = placeholder
    }

    public func makeUIView(context: Context) -> UISearchBar {
        let view = UISearchBar()
        view.delegate = context.coordinator
        view.placeholder = placeholder
        view.text = text.wrappedValue
        searchBarStyle.configure(view)
        return view
    }

    public func updateUIView(_ view: UISearchBar, context: Context) {
        view.text = text.wrappedValue
        context.coordinator.parent = self
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public final class Coordinator: NSObject, UISearchBarDelegate {

        var parent: SearchBar

        init(parent: SearchBar) {
            self.parent = parent
        }

        public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            parent.searchBarStyle.delegate?.searchBarShouldBeginEditing?(searchBar) ?? true
        }

        public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            parent.searchBarStyle.delegate?.searchBarTextDidEndEditing?(searchBar)
            searchBar.setShowsCancelButton(true, animated: true)
        }

        public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
            parent.searchBarStyle.delegate?.searchBarShouldEndEditing?(searchBar) ?? true
        }

        public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            parent.searchBarStyle.delegate?.searchBarTextDidEndEditing?(searchBar)
            searchBar.setShowsCancelButton(false, animated: true)
        }

        public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.searchBarStyle.delegate?.searchBar?(searchBar, textDidChange: searchText)
            parent.text.wrappedValue = searchText
        }

        public func searchBar(
            _ searchBar: UISearchBar,
            shouldChangeTextIn range: NSRange,
            replacementText text: String
        ) -> Bool {
            parent.searchBarStyle.delegate?.searchBar?(
                searchBar,
                shouldChangeTextIn: range,
                replacementText: text
            ) ?? true
        }

        public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            parent.searchBarStyle.delegate?.searchBarSearchButtonClicked?(searchBar)
            searchBar.resignFirstResponder()
        }

        public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
            parent.searchBarStyle.delegate?.searchBarBookmarkButtonClicked?(searchBar)
        }

        public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            parent.searchBarStyle.delegate?.searchBarCancelButtonClicked?(searchBar)
            searchBar.resignFirstResponder()
        }

        public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
            parent.searchBarStyle.delegate?.searchBarResultsListButtonClicked?(searchBar)
        }

        public func searchBar(
            _ searchBar: UISearchBar,
            selectedScopeButtonIndexDidChange selectedScope: Int
        ) {
            parent.searchBarStyle.delegate?.searchBar?(
                searchBar,
                selectedScopeButtonIndexDidChange: selectedScope
            )
        }
    }
}
