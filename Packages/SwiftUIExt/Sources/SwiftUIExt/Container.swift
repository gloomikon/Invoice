import SwiftUI

public struct Container<Content: View>: View {

    let alignment: Alignment
    let clip: Bool
    let content: Content

    public init(
        alignment: Alignment = .center,
        clip: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.clip = clip
        self.content = content()
    }

    public var body: some View {
        let body =
        Color.clear
            .overlay(alignment: alignment) {
                content
            }
        if clip {
            body.clipped()
        } else {
            body
        }
    }
}
