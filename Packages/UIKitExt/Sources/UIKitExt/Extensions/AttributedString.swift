import UIKit

public extension AttributedString {

    @discardableResult
    func setFont(
        _ font: UIFont,
        to substring: String? = nil
    ) -> Self {
        var modifiedString = self

        if let substring, let range = modifiedString.range(of: substring) {
            modifiedString[range].font = font
        } else if substring == nil {
            modifiedString.font = font
        }

        return modifiedString
    }

    @discardableResult
    func setForegroundColor(
        _ color: UIColor,
        to substring: String? = nil
    ) -> Self {
        var modifiedString = self

        if let substring, let range = modifiedString.range(of: substring) {
            modifiedString[range].foregroundColor = color
        } else if substring == nil {
            modifiedString.foregroundColor = color
        }

        return modifiedString
    }

    @discardableResult
    func setBackgroundColor(
        _ color: UIColor,
        to substring: String? = nil
    ) -> Self {
        var modifiedString = self

        if let substring, let range = modifiedString.range(of: substring) {
            modifiedString[range].backgroundColor = color
        } else if substring == nil {
            modifiedString.backgroundColor = color
        }

        return modifiedString
    }

    @discardableResult
    func setKern(
        _ kern: Double,
        to substring: String? = nil
    ) -> Self {
        var modifiedString = self

        if let substring, let range = modifiedString.range(of: substring) {
            modifiedString[range].kern = kern
        } else if substring == nil {
            modifiedString.kern = kern
        }

        return modifiedString
    }

    @discardableResult
    func setStrikethrough(
        _ style: NSUnderlineStyle = .single,
        color: UIColor? = nil,
        to substring: String? = nil
    ) -> Self {
        var modifiedString = self

        if let substring, let range = modifiedString.range(of: substring) {
            modifiedString[range].strikethroughStyle = style
            if let color {
                modifiedString[range].strikethroughColor = color
            }
        } else if substring == nil {
            modifiedString.strikethroughStyle = style
            if let color {
                modifiedString.strikethroughColor = color
            }
        }

        return modifiedString
    }
}
