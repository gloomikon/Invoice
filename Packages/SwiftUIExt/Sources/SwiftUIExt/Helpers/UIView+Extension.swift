import SwiftUI

extension UIView {

    func add<View: SwiftUI.View>(_ view: View, insets: UIEdgeInsets = .zero) {
        let hosting = UIHostingController(rootView: view)
        hosting.view.pin(to: self, insets: insets)
        hosting.view.backgroundColor = .clear
    }

    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
        ])
    }
}
