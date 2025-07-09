import Foundation

struct InvoicePageMetrics {

    enum PageFormat {

        case usLetter
        case a4

        var size: CGSize {
            switch self {
            case .usLetter:
                .init(width: 612, height: 792)
            case .a4:
                .init(width: 595, height: 842)
            }
        }
    }

    let pageWidth: CGFloat
    let pageHeight: CGFloat
    let margin: CGFloat
    let lineHeight: CGFloat
    let bottomMargin: CGFloat

    var contentWidth: CGFloat {
        pageWidth - margin * 2
    }

    init(
        pageFormat: PageFormat,
        margin: CGFloat,
        lineHeight: CGFloat,
        bottomMargin: CGFloat
    ) {
        self.pageWidth = pageFormat.size.width
        self.pageHeight = pageFormat.size.height
        self.margin = margin
        self.lineHeight = lineHeight
        self.bottomMargin = bottomMargin
    }
}
