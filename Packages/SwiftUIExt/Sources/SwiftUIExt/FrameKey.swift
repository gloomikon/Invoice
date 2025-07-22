import SwiftUI

public struct FrameKey: PreferenceKey {
    public static let defaultValue: CGRect? = nil
    public static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue()
    }
}

public extension View {

    func onFrameChange(
        perform action: (@MainActor (CGRect) -> Void)? = nil
    ) -> some View {
        overlay {
            GeometryReader { proxy in
                Color.clear.preference(key: FrameKey.self, value: proxy.frame(in: .global))
            }
        }
        .onPreferenceChange(FrameKey.self) { frame in
            frame.map { action?($0) }
        }
    }

    func onFrameChange(_ frame: Binding<CGRect>) -> some View {
        onFrameChange { rect in
            Task { @MainActor in frame.wrappedValue = rect }
        }
    }

    func onSizeChange(_ frame: Binding<CGSize>) -> some View {
        onFrameChange { rect in
            Task { @MainActor in frame.wrappedValue = rect.size }
        }
    }

    func onHeightChange(_ frame: Binding<CGFloat>) -> some View {
        onFrameChange { rect in
            Task { @MainActor in frame.wrappedValue = rect.height }
        }
    }

    func onWidthChange(_ frame: Binding<CGFloat>) -> some View {
        onFrameChange { rect in
            Task { @MainActor in frame.wrappedValue = rect.width }
        }
    }

    func onWidthChange(
        perform action: (@MainActor (CGFloat) -> Void)? = nil
    ) -> some View {
        onFrameChange { rect in
            Task { @MainActor in action?(rect.width) }
        }
    }
}
