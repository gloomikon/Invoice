import Foundation

public struct SimpleLog: Identifiable {

    public let id = UUID()
    public let text: String
    public let date = Date()

    public init(_ text: String) {
        self.text = text
    }
}
