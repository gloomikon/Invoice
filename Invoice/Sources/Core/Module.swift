import UIKit
import XCoordinator

protocol Module: Presentable {

    func build() -> UIViewController
}

extension Module {
    var viewController: UIViewController! {
        build()
    }
}

class ModuleBuilder {

    func build(_ module: Module) -> UIViewController {
        module.build()
    }
}
