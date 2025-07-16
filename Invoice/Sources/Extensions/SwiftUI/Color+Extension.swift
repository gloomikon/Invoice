import SwiftUI

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Remove "#" prefix if it exists
        let hexString = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex

        // Ensure valid hex length
        guard hexString.count == 6 else {
            self = .clear
            return
        }

        // Convert hex to RGB values
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
