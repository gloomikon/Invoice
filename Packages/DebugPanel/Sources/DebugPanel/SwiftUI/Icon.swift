import SwiftUI

struct Icon: View {

    let icon: Image
    let tintColor: Color?
    let backgroundColor: Color?

    var body: some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15)
            .foregroundStyle(tintColor ?? Color(.label))
            .padding(5)
            .background(backgroundColor ?? .clear, in: .rect(cornerRadius: 6))
    }
}
