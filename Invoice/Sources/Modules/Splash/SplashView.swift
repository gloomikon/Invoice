import SwiftUI

struct SplashView: View {

    @ObservedObject var viewModel: SplashViewModel

    var body: some View {
        VStack {
            Spacer()
            Text("Splash")
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.pink)
    }
}
