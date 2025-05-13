import UIKit

extension AttributedString {

    @discardableResult
    func setBackgroundColor(
        _ color: UIColor,
        to substring: String? = nil,
        caseInsensitive: Bool = false
    ) -> Self {
        var modifiedString = self

        if let substring {
            var searchString = modifiedString[modifiedString.startIndex...]
            while let range = searchString.range(
                of: substring,
                options: caseInsensitive ? [.caseInsensitive] : []
            ) {
                modifiedString[range].backgroundColor = color
                searchString = searchString[range.upperBound...]
            }
        } else if substring == nil {
            modifiedString.backgroundColor = color
        }

        return modifiedString
    }
}
