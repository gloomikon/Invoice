import SwiftUI

struct NoInternetConnectionView: View {

    let tryAgain: () -> Void

    var body: some View {
        Color.linkedIn
            .overlay {
                Rectangle()
                    .fill(Color.black)
                    .opacity(0.8)
            }
            .overlay {
                VStack {
                    Image(systemName: "wifi.exclamationmark")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 50, height: 50)

                    Text("No internet connection")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .foregroundStyle(.white)
            }
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                Button("Try Again") {
                    tryAgain()
                }
                .buttonStyle(.primary)
                .padding(.horizontal, 20)
                .padding(.bottom, 47)
            }
    }
}
