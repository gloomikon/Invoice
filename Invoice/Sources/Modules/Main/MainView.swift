import SwiftUI

struct MainView: View {

    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        Text("Main")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.orange)
    }
}
