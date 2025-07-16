import SwiftUI

struct SplashView: View {

    @ObservedObject var viewModel: SplashViewModel

    @State private var animateID = UUID()

    var body: some View {
        VStack {
            if viewModel.showNoInternetConnection {
                NoInternetConnectionView {
                    viewModel.tryAgain()
                }
            } else {
                Image(.logo)
                    .resizable()
                    .aspectRatio(82.5 / 100, contentMode: .fit)
                    .frame(width: 100)
                    .background {
                        PulsatingCircles()
                            .frame(width: 250, height: 250)
                            .id(animateID)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .background {
                        Color.linkedIn
                            .ignoresSafeArea()
                    }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showNoInternetConnection)
        .onAppear {
            animateID = UUID()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            animateID = UUID()
        }
    }
}

private struct PulsatingCircles: View {

    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .fill(
                        .white.opacity(0.1).shadow(.inner(color: .linkedIn.opacity(0.5), radius: 8))
                    )
                    .scaleEffect(animate ? 2.5 : 1)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 2.4)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.8),
                        value: animate
                    )
                Circle()
                    .fill(Color(hex: "#3180CB"))
            }
        }
        .onAppear {
            animate = true
        }
    }
}
