import SwiftUI

struct SplashView: View {

    @ObservedObject var viewModel: SplashViewModel

    var body: some View {
        VStack {
            Spacer()
            Text("Splash")
            Spacer()
            Button("Continue") {
                viewModel.openOnboarding()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.pink)
    }
}
