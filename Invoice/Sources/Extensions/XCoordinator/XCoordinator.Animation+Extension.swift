import UIKitExt
import XCoordinator

extension XCoordinator.Animation {
    static let fade = Animation(
        presentation: InteractiveTransitionAnimation.fadeIn,
        dismissal: InteractiveTransitionAnimation.fadeOut
    )

    static let fadeZoom = Animation(
        presentation: InteractiveTransitionAnimation.fadeZoom,
        dismissal: InteractiveTransitionAnimation.fadeZoom
    )
}

extension XCoordinator.InteractiveTransitionAnimation {

    private enum Constant {
        static let animationDuration: TimeInterval = 0.3
    }

    fileprivate static let fadeIn = InteractiveTransitionAnimation(
        duration: Constant.animationDuration
    ) { context in
        let containerView = context.containerView
        let toView: UIView? = if let view = context.view(forKey: .to) {
            view
        } else if let viewController = context.viewController(forKey: .to) {
            viewController.view
        } else {
            nil
        }
        guard let toView else {
            return context.completeTransition(false)
        }

        toView.alpha = 0.0
        containerView.addSubview(toView)

        UIView.animate(
            withDuration: Constant.animationDuration,
            delay: 0,
            options: [.curveLinear]
        ) {
            toView.alpha = 1.0
        } completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        }
    }

    fileprivate static let fadeOut = InteractiveTransitionAnimation(
        duration: Constant.animationDuration
    ) { context in
        let containerView = context.containerView

        guard let fromView = context.view(forKey: .from) else {
            return context.completeTransition(false)
        }

        let toView: UIView? = if let view = context.view(forKey: .to) {
            view
        } else if let viewController = context.viewController(forKey: .to) {
            viewController.view
        } else {
            nil
        }
        guard let toView else {
            return context.completeTransition(false)
        }

        containerView.insertSubview(toView, at: 0)

        UIView.animate(
            withDuration: Constant.animationDuration,
            delay: 0,
            options: [.curveLinear]
        ) {
            fromView.alpha = 0.0
        } completion: { _ in
//            overlayView.removeFromSuperview()
            let finished = !context.transitionWasCancelled
            if finished {
                UIApplication.keyWindow?.subviews.dropLast().last?.addSubview(toView)
            }
            context.completeTransition(finished)
        }
    }

    fileprivate static let fadeZoom = InteractiveTransitionAnimation(
        duration: Constant.animationDuration
    ) { context in
        let containerView = context.containerView
        guard let toView = context.view(forKey: .to),
              let fromView: UIView = context.view(forKey: .from) else {
            return context.completeTransition(false)
        }

        toView.alpha = 0.0
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)

        UIView.animate(
            withDuration: Constant.animationDuration,
            delay: 0,
            options: [.curveLinear]
        ) {
            toView.alpha = 1.0
            fromView.transform = CGAffineTransform(scaleX: 2, y: 2)
        } completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}
