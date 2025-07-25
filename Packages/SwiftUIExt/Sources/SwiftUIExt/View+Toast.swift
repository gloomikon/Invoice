import SwiftUI

public enum ToastLocation {
    case top
    case bottom

    public var alignment: Alignment {
        switch self {
        case .top:
                .top
        case .bottom:
                .bottom
        }
    }

    public var edge: Edge {
        switch self {
        case .top:
                .top
        case .bottom:
                .bottom
        }
    }

    public var swipeDirection: SwipeDirection {
        switch self {
        case .top:
                .up
        case .bottom:
                .down
        }
    }
}

public extension View {

    func toast<Toast: View>(
        isPresented: Binding<Bool>,
        location: ToastLocation,
        onAppear: (() -> Void)? = nil,
        @ViewBuilder toast: () -> Toast
    ) -> some View {
        ZStack(alignment: location.alignment) {
            self

            if isPresented.wrappedValue {
                toast()
                    .zIndex(1)
                    .transition(.move(edge: location.edge).combined(with: .opacity))
                    .onSwipe(location.swipeDirection) {
                        isPresented.wrappedValue = false
                    }
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                            isPresented.wrappedValue = false
                        }
                        onAppear?()
                    }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isPresented.wrappedValue)
    }
}
