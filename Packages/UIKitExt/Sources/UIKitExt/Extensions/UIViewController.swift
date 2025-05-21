import UIKit

public extension UIViewController {

    var wrappedInNavigationController: UINavigationController {
        UINavigationController(rootViewController: self)
    }
}
