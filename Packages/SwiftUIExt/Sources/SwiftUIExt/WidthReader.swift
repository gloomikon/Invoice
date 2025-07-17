import SwiftUI

public struct WidthReader<Content: View>: View {

    @State private var width: CGFloat = 0

    private let content: (CGFloat) -> Content

    public init(
        @ViewBuilder content: @escaping (CGFloat) -> Content
    ) {
        self.content = content
    }

    public var body: some View {
        VStack(spacing: .zero) {
            GeometryReader { proxy in
                Color.clear
                    .onAppear { width = proxy.size.width }
                    .onChange(of: proxy.size.width) { width = $0 }
            }
            .frame(height: 0)
            content(width)
        }
    }
}
