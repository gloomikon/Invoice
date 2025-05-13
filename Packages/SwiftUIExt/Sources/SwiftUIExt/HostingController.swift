import SwiftUI

open class HostingController<View: SwiftUI.View>: UIViewController {

    private let rootView: View

    private var viewWasAdded = false

    public init(rootView: View) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)

        if viewWasAdded { return }
        defer { viewWasAdded = true }
        view.add(rootView)
    }
}
