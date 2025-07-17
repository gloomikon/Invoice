import SwiftUI

struct GridShape: Shape {

    var spacing: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Draw vertical lines
        for x in stride(from: rect.minX, to: rect.maxX, by: spacing) {
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }

        // Draw horizontal lines
        for y in stride(from: rect.minY, to: rect.maxY, by: spacing) {
            if y == rect.maxY { continue }
            path.move(to: CGPoint(x: rect.minX, y: y))
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }

        return path
    }
}
