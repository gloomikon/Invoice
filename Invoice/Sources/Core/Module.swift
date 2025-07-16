import UIKit
import XCoordinator

@MainActor protocol Module {

    func build() -> UIViewController
}

@MainActor
class ModuleBuilder {

    func build(_ module: Module) -> UIViewController {
        module.build()
    }
}
