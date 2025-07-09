import PDFKit
import SwiftUI
import UIKit

protocol InvoiceRenderable {

    func render(from input: InvoiceInput) -> Data
}

class CommonInvoiceRenderer: InvoiceRenderable {

    func render(from invoice: InvoiceInput) -> Data {
        let renderer = CommonPDFRenderer(
            invoice: invoice,
            metrics: InvoicePageMetrics(
                pageFormat: .usLetter,
                margin: 36,
                lineHeight: 18,
                bottomMargin: 48
            ),
            currencyFormatter: {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.currencyCode = invoice.currency.code
                numberFormatter.currencySymbol = invoice.currency.symbol
                numberFormatter.maximumFractionDigits = 2
                return numberFormatter
            }(),
            dateFormatter: {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                return dateFormatter
            }(),
            textColor: .black,
            tableBorderColor: .black,
            headersFillColor: .systemGray6
        )

        return renderer.pdfData(actions: renderer.renderingActions)
    }
}

private class CommonPDFRenderer: UIGraphicsPDFRenderer {

    enum Column: String, CaseIterable {

        case description = "Description"
        case quantity = "QTY"
        case price = "Price"
        case amount = "Amount"

        var headerTitle: String {
            rawValue
        }

        var widthMultiplier: CGFloat {
            switch self {
            case .description:
                0.46
            case .quantity:
                0.12
            case .price:
                0.20
            case .amount:
                0.22
            }
        }

        func width(with metrics: InvoicePageMetrics) -> CGFloat {
            metrics.contentWidth * widthMultiplier
        }
    }

    let invoice: InvoiceInput
    let metrics: InvoicePageMetrics
    let currencyFormatter: NumberFormatter
    let dateFormatter: DateFormatter

    let textColor: UIColor
    let tableBorderColor: UIColor
    let headersFillColor: UIColor

    private lazy var totals = invoice.totals
    private var currentPageIndex = 0

    init(
        invoice: InvoiceInput,
        metrics: InvoicePageMetrics,
        currencyFormatter: NumberFormatter,
        dateFormatter: DateFormatter,
        textColor: UIColor,
        tableBorderColor: UIColor,
        headersFillColor: UIColor
    ) {
        self.invoice = invoice
        self.metrics = metrics
        self.currencyFormatter = currencyFormatter
        self.dateFormatter = dateFormatter
        self.textColor = textColor
        self.tableBorderColor = tableBorderColor
        self.headersFillColor = headersFillColor

        super.init(
            bounds: CGRect(
                x: .zero,
                y: .zero,
                width: metrics.pageWidth,
                height: metrics.pageHeight
            ),
            format: .init()
        )
    }

    lazy var renderingActions: ((UIGraphicsPDFRendererContext) -> Void) = { [weak self] context in
        guard let self else { return }

        // Begin First Page
        context.beginPage()
        currentPageIndex = 0
        var currentY = metrics.margin

        // Business Name (top-left)
        drawText(
            invoice.issuer.name,
            font: .boldSystemFont(ofSize: 22),
            at: CGPoint(x: metrics.margin, y: currentY)
        )

        // Invoice meta block (top-right)
        let metaBlockWidth = metrics.pageWidth * 0.3
        let rightX = metrics.pageWidth - metrics.margin - metaBlockWidth
        drawText(
            "INVOICE",
            font: .boldSystemFont(ofSize: 18),
            at: CGPoint(x: rightX, y: currentY),
            align: .right,
            maxWidth: metaBlockWidth
        )
        currentY += metrics.lineHeight + 4

        drawText(
            "#\(invoice.number)",
            font: .systemFont(ofSize: 11),
            at: CGPoint(x: rightX, y: currentY),
            align: .right,
            maxWidth: metaBlockWidth
        )
        currentY += metrics.lineHeight

        drawText(
            "Due \(dateFormatter.string(from: invoice.dueDate ?? invoice.issuedDate))",
            font: .systemFont(ofSize: 11),
            at: CGPoint(x: rightX, y: currentY),
            align: .right,
            maxWidth: metaBlockWidth
        )
        currentY += metrics.lineHeight

        drawText(
            "Issued \(dateFormatter.string(from: invoice.issuedDate))",
            font: .systemFont(ofSize: 11),
            at: CGPoint(x: rightX, y: currentY),
            align: .right,
            maxWidth: metaBlockWidth
        )
        currentY = metrics.margin + metrics.lineHeight * 4 + 12

        // FROM / BILL TO blocks
        let columnWidth = metrics.contentWidth * 0.5

        drawText(
            "FROM",
            font: .boldSystemFont(ofSize: 10),
            at: CGPoint(x: metrics.margin, y: currentY)
        )

        drawText(
            "BILL TO",
            font: .boldSystemFont(ofSize: 10),
            at: CGPoint(x: metrics.margin * 2 + columnWidth, y: currentY)
        )
        currentY += metrics.lineHeight

        let issuerFieldsCount = drawParty(
            invoice.issuer,
            at: CGPoint(x: metrics.margin, y: currentY)
        )
        let recipientFieldsCount = drawParty(
            invoice.recipient,
            at: CGPoint(x: metrics.margin * 2 + columnWidth, y: currentY)
        )
        let maxPartyFieldsCount = max(issuerFieldsCount, recipientFieldsCount)
        currentY += maxPartyFieldsCount * metrics.lineHeight + 12

        // Work Items Table
        drawTableHeader(in: context.cgContext, y: &currentY)

        let descriptionColumnWidth = Column.description.width(with: metrics)
        let quantityColumnWidth = Column.quantity.width(with: metrics)
        let priceColumnWidth = Column.price.width(with: metrics)
        let amountColumnWidth = Column.amount.width(with: metrics)

        for item in invoice.workItems {
            let hasDescription = item.description?.isEmpty == false
            let hasDiscount = item.discount != nil

            var rowsRequired: CGFloat = 1
            if hasDescription { rowsRequired += 1 }
            if hasDiscount { rowsRequired += 1 }
            let rowHeight = rowsRequired * metrics.lineHeight

            currentY = beginPageIfNeeded(
                context: context,
                currentY: currentY,
                requiredSpace: rowHeight
            )
            var x = metrics.margin

            // Description (+ optional note)
            drawText(
                item.name,
                font: .boldSystemFont(ofSize: 12),
                at: CGPoint(x: x + 4, y: currentY),
                maxWidth: descriptionColumnWidth
            )
            if let description = item.description, !description.isEmpty {
                drawText(
                    description,
                    font: .systemFont(ofSize: 11),
                    at: CGPoint(x: x + 4, y: currentY + metrics.lineHeight),
                    maxWidth: descriptionColumnWidth
                )
            }
            if let discount = item.discount {
                let discountTitle: String
                switch discount {
                case let .percentage(value):
                    discountTitle = "Incl. \(value)% discount"
                case let .fixed(amount):
                    let discountAmount = currencyFormatter.string(from: NSNumber(value: amount)) ?? ""
                    discountTitle = "Incl. \(discountAmount) Discount"
                }

                drawText(
                    discountTitle,
                    color: textColor.withAlphaComponent(0.6),
                    font: .systemFont(ofSize: 11),
                    at: CGPoint(x: x + 4, y: currentY + metrics.lineHeight * 2),
                    maxWidth: descriptionColumnWidth
                )
            }
            x += descriptionColumnWidth

            // Quantity
            drawText(
                String(format: "%.1f", item.quantity),
                at: CGPoint(x: x - 4, y: currentY),
                align: .right,
                maxWidth: quantityColumnWidth
            )
            x += quantityColumnWidth

            // Price
            drawText(
                currencyFormatter.string(from: NSNumber(value: item.price)) ?? "",
                at: CGPoint(x: x - 4, y: currentY),
                align: .right,
                maxWidth: priceColumnWidth
            )
            x += priceColumnWidth

            // Amount
            drawText(
                currencyFormatter.string(from: NSNumber(value: item.amount)) ?? "",
                at: CGPoint(x: x - 4, y: currentY),
                align: .right,
                maxWidth: amountColumnWidth
            )

            // Draw border lines
            let cgContext = context.cgContext

            cgContext.setStrokeColor(tableBorderColor.cgColor)
            cgContext.setLineWidth(0.5)

            // Top border
            cgContext.move(to: CGPoint(x: metrics.margin, y: currentY))
            cgContext.addLine(to: CGPoint(x: metrics.pageWidth - metrics.margin, y: currentY))

            // Bottom border
            cgContext.move(to: CGPoint(x: metrics.margin, y: currentY + rowHeight))
            cgContext.addLine(to: CGPoint(x: metrics.pageWidth - metrics.margin, y: currentY + rowHeight))

            // Vertical column lines
            x = metrics.margin
            Column.allCases
                .map { $0.width(with: self.metrics) }
                .forEach { width in
                cgContext.move(to: CGPoint(x: x, y: currentY))
                cgContext.addLine(to: CGPoint(x: x, y: currentY + rowHeight))
                x += width
            }
            cgContext.move(to: CGPoint(x: x, y: currentY))
            cgContext.addLine(to: CGPoint(x: x, y: currentY + rowHeight))

            cgContext.strokePath()
            currentY += rowHeight
        }

        // Summary
        currentY += metrics.lineHeight

        drawSummaryRow(
            title: "Subtotal",
            amount: totals.subtotal,
            font: .boldSystemFont(ofSize: 12),
            currentY: &currentY,
            priceColumnWidth: priceColumnWidth,
            amountColumnWidth: amountColumnWidth,
            context: context.cgContext
        )
        if totals.discountValue > 0 {
            let discountTitle: String
            switch invoice.discount {
            case .percentage(let amount):
                discountTitle = "Discount \(amount)%"
            case .fixed, .none:
                discountTitle = "Discount"
            }
            drawSummaryRow(
                title: discountTitle,
                amount: -totals.discountValue,
                font: .systemFont(ofSize: 12),
                currentY: &currentY,
                priceColumnWidth: priceColumnWidth,
                amountColumnWidth: amountColumnWidth,
                context: context.cgContext
            )
        }
        if totals.taxValue > 0 {
            let taxTitle: String
            switch invoice.tax {
            case .exclusive(let amount):
                taxTitle = "Tax \(amount)%"
            case .inclusive(let amount):
                taxTitle = "Tax (incl.) \(amount)%"
            case .none:
                taxTitle = "Tax"
            }
            drawSummaryRow(
                title: taxTitle,
                amount: totals.taxValue,
                font: .systemFont(ofSize: 12),
                currentY: &currentY,
                priceColumnWidth: priceColumnWidth,
                amountColumnWidth: amountColumnWidth,
                context: context.cgContext
            )
        }
        drawSummaryRow(
            title: "Total",
            amount: totals.total,
            font: .boldSystemFont(ofSize: 13),
            isBordered: false,
            currentY: &currentY,
            priceColumnWidth: priceColumnWidth,
            amountColumnWidth: amountColumnWidth,
            context: context.cgContext
        )

        // Signature
        if let signature = invoice.signature {
            let maxWidth: CGFloat = 140
            let maxHeight: CGFloat = 70

            let signatureSize = signature.size
            let aspectRatio = signatureSize.width / signatureSize.height

            var renderWidth = maxWidth
            var renderHeight = renderWidth / aspectRatio

            if renderHeight > maxHeight {
                renderHeight = maxHeight
                renderWidth = renderHeight * aspectRatio
            }

            currentY += metrics.lineHeight
            drawImage(
                signature,
                at: CGPoint(
                    x: metrics.pageWidth - metrics.margin - amountColumnWidth - renderWidth / 2,
                    y: currentY
                ),
                size: .init(width: renderWidth, height: renderHeight)
            )
            currentY += renderHeight
        }

        //  Footer for last page
        drawFooter(in: context.cgContext)
    }

    /// Starts a new page and draws footer for previous one and repeating header for new one.
    func beginPageIfNeeded(
        context: UIGraphicsPDFRendererContext,
        currentY: CGFloat,
        requiredSpace: CGFloat
    ) -> CGFloat {
        var y = currentY
        if y + requiredSpace > metrics.pageHeight - metrics.bottomMargin {
            drawFooter(in: context.cgContext)
            context.beginPage()
            currentPageIndex += 1
            y = metrics.margin
            drawTableHeader(in: context.cgContext, y: &y) // repeat table headers
        }
        return y
    }

    /// Draws text
    func drawText(
        _ text: String,
        color: UIColor? = nil,
        font: UIFont = .systemFont(ofSize: 12),
        at point: CGPoint,
        align: NSTextAlignment = .left,
        maxWidth: CGFloat = .greatestFiniteMagnitude
    ) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = align

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color ?? textColor,
            .font: font,
            .paragraphStyle: paragraph
        ]

        let rect = CGRect(
            origin: point,
            size: CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )

        text.draw(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
    }

    // Draw image
    func drawImage(
        _ image: UIImage,
        at point: CGPoint,
        size: CGSize
    ) {
        image.draw(in: CGRect(
            x: point.x,
            y: point.y,
            width: size.width,
            height: size.height
        ))
    }

    /// Draws party
    func drawParty(
        _ party: InvoiceInput.Party,
        at point: CGPoint
    ) -> CGFloat {
        let x = point.x
        var y = point.y
        var addetFieldsCount: CGFloat = 0

        drawText(
            party.name,
            font: .boldSystemFont(ofSize: 13),
            at: CGPoint(x: x, y: y)
        )
        y += metrics.lineHeight
        addetFieldsCount += 1

        drawText(
            party.phoneNumber,
            at: CGPoint(x: x, y: y)
        )
        y += metrics.lineHeight
        addetFieldsCount += 1

        if let email = party.email {
            drawText(
                email,
                at: CGPoint(x: x, y: y)
            )
            y += metrics.lineHeight
            addetFieldsCount += 1
        }

        drawText(
            party.address,
            at: CGPoint(x: x, y: y)
        )
        addetFieldsCount += 1

        return addetFieldsCount
    }

    /// Draws summary's title and amount in a row
    func drawSummaryRow(
        title: String,
        amount: Double,
        font: UIFont,
        isBordered: Bool = true,
        currentY: inout CGFloat,
        priceColumnWidth: CGFloat,
        amountColumnWidth: CGFloat,
        context: CGContext
    ) {
        let mostRightX = metrics.pageWidth - metrics.margin
        let mostLeftX = mostRightX - priceColumnWidth - amountColumnWidth

        drawText(
            title,
            font: font,
            at: CGPoint(x: mostLeftX - 4, y: currentY),
            align: .right,
            maxWidth: priceColumnWidth
        )
        drawText(
            currencyFormatter.string(from: NSNumber(value: amount)) ?? "",
            font: font,
            at: CGPoint(x: mostLeftX + priceColumnWidth - 4, y: currentY),
            align: .right,
            maxWidth: amountColumnWidth
        )

        guard isBordered else {
            currentY += metrics.lineHeight
            return
        }

        // Draw border lines
        context.setStrokeColor(tableBorderColor.cgColor)
        context.setLineWidth(0.5)

        // Top border
        context.move(to: CGPoint(x: mostLeftX, y: currentY))
        context.addLine(to: CGPoint(x: mostRightX, y: currentY))

        // Bottom border
        context.move(to: CGPoint(x: mostLeftX, y: currentY + metrics.lineHeight))
        context.addLine(to: CGPoint(x: mostRightX, y: currentY + metrics.lineHeight))

        // Vertical borders
        let topY = currentY
        let bottomY = currentY + metrics.lineHeight

        context.move(to: CGPoint(x: mostLeftX, y: topY))
        context.addLine(to: CGPoint(x: mostLeftX, y: bottomY))

        context.move(to: CGPoint(x: mostLeftX + priceColumnWidth, y: topY))
        context.addLine(to: CGPoint(x: mostLeftX + priceColumnWidth, y: bottomY))

        context.move(to: CGPoint(x: mostRightX, y: topY))
        context.addLine(to: CGPoint(x: mostRightX, y: bottomY))

        context.strokePath()
        currentY += metrics.lineHeight
    }

    /// Draws table header
    func drawTableHeader(
        in context: CGContext,
        y: inout CGFloat
    ) {
        let columns = Column.allCases

        // Draw header background
        let headerHeight = metrics.lineHeight + 6
        let headerRect = CGRect(
            x: metrics.margin,
            y: y,
            width: metrics.contentWidth,
            height: headerHeight
        )
        context.setFillColor(headersFillColor.cgColor)
        context.fill(headerRect)

        // Draw column titles
        var x = metrics.margin
        columns.enumerated().forEach { index, column in
            let columnWidth = column.width(with: metrics)
            drawText(
                column.headerTitle,
                font: .boldSystemFont(ofSize: 11),
                at: CGPoint(x: x + 4, y: y + 4),
                align: (index == 0 ? .left : .right),
                maxWidth: columnWidth - 8
            )
            x += columnWidth
        }

        // Draw border lines
        context.setStrokeColor(tableBorderColor.cgColor)
        context.setLineWidth(0.5)

        // Top border
        context.move(to: CGPoint(x: metrics.margin, y: y))
        context.addLine(to: CGPoint(x: metrics.pageWidth - metrics.margin, y: y))

        // Bottom border
        context.move(to: CGPoint(x: metrics.margin, y: y + headerHeight))
        context.addLine(to: CGPoint(x: metrics.pageWidth - metrics.margin, y: y + headerHeight))

        // Vertical column lines
        x = metrics.margin
        columns.map { $0.width(with: metrics) }
            .forEach { width in
                context.move(to: CGPoint(x: x, y: y))
                context.addLine(to: CGPoint(x: x, y: y + headerHeight))
                x += width
            }
        context.move(to: CGPoint(x: x, y: y))
        context.addLine(to: CGPoint(x: x, y: y + headerHeight))

        context.strokePath()
        y += headerHeight
    }

    /// Draws page footer
    func drawFooter(in context: CGContext) {
        let footerText = "Invoice #\(invoice.number) Page \(currentPageIndex + 1)"
        let size = footerText.size(withAttributes: [.font: UIFont.systemFont(ofSize: 10)])
        let x = metrics.margin
        let y = metrics.pageHeight - metrics.bottomMargin + (metrics.bottomMargin - size.height) / 2
        drawText(
            footerText,
            font: .systemFont(ofSize: 10),
            at: CGPoint(x: x, y: y)
        )
    }
}

// MARK: - Preview

enum InputMock {
    static var input: InvoiceInput {
        .init(
            id: "#123",
            number: "4",
            issuedDate: .now,
            dueDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
            issuer: .init(
                name: "Sam Porter",
                address: "Denver, Parkway drive",
                phoneNumber: "+1 123 426 1559",
                email: "portersolutions@example.com",
                taxId: "11997733"
            ),
            recipient: .init(
                name: "Coca Cola INC",
                address: "New York City, Lincoln street",
                phoneNumber: "+1 123 456 7890",
                email: "cocacolasupport@example.com",
                taxId: "27840177"
            ),
            workItems: [
                .init(
                    name: "Some Work",
                    description: "Some work finished some time ago",
                    price: 500,
                    quantity: 2,
                    unitType: .item,
                    discount: .percentage(amount: 10),
                    taxable: true,
                    saveToCatalog: true
                ),
                .init(
                    name: "Some Work 2",
                    description: "Some work finished some time ago too",
                    price: 100,
                    quantity: 9,
                    unitType: .hour,
                    discount: .fixed(amount: 50),
                    taxable: true,
                    saveToCatalog: true
                )
            ],
            currency: .init(code: "403", symbol: "$"),
            discount: .percentage(amount: 5),
            tax: .exclusive(amount: 10),
            paymentMethods: [.payPal(link: "paypalme", email: "someLink@paypal.com")],
            signature: .icSignatureExample,
            notes: "Best regards and thank you!"
        )
    }
}

struct PDFInvoicePreview: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = PDFDocument(data: data)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(data: data)
    }
}

#Preview {
    let data = CommonInvoiceRenderer().render(from: InputMock.input)
    PDFInvoicePreview(data: data)
}
