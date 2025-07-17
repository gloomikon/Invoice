import SwiftUI

struct Icon: View {

    private let image: Image

    init(_ name: String) {
        image = Image(name)
    }

    init(systemName: String) {
        image = Image(systemName: systemName)
    }

    init(uiImage: UIImage) {
        image = Image(uiImage: uiImage)
    }

    init(_ resource: ImageResource) {
        image = Image(resource)
    }

    var body: some View {
        image
            .resizable()
            .renderingMode(.template)
    }
}
