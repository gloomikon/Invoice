import UIKit

public protocol SelectionHaptic { }

public extension SelectionHaptic {
    func fire() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

public struct SelectionFeedback: SelectionHaptic { }

public extension SelectionHaptic where Self == SelectionFeedback {

    static var selection: Self {
        Self()
    }
}
