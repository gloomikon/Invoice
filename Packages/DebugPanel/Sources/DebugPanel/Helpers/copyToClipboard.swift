import UIKit

public func copyToClipboard(_ string: String) {
    UIPasteboard.general.string = string
}
