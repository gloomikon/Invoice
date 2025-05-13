import Combine
import UIKit

open class DebugPanelWindow: UIWindow {

    open var shouldDisplayPanel: Bool {
        false
    }

    open func setup() {

    }

    private var groups: [Group] = []

    public final func setupGroups(
        @GroupBuilder groups: () -> [Group]
    ) {
        self.groups = groups()
    }

    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        guard shouldDisplayPanel, motion == .motionShake else { return }

        guard let topViewController = rootViewController?.topViewController else { return }

        setup()

        DebugPanelCoordinator(rootViewController: topViewController, groups: groups)
            .start()
    }
}

extension UIViewController {
    var topViewController: UIViewController {
        var topViewController = self
        while let currentViewController = topViewController.presentedViewController {
            topViewController = currentViewController
        }
        return topViewController
    }
}
