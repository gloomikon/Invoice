import SwiftUI

struct OnboardingView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack {
            Spacer()
            Text("Onboarding")
            Spacer()
            Button("Continue") {
                viewModel.openPaywall()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.purple)
    }
}
