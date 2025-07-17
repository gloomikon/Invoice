import UIKit

public extension UIFont {

    static func customFont(
        _ name: String,
        size: CGFloat,
        textStyle: UIFont.TextStyle? = nil,
        scaled: Bool = false
    ) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            print("Warning: Font \(name) not found.")
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }

        if scaled, let textStyle = textStyle {
            let metrics = UIFontMetrics(forTextStyle: textStyle)
            return metrics.scaledFont(for: font)
        } else {
            return font
        }
    }
}
