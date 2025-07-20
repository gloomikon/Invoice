import UIKit

protocol InvoiceRenderable {

    func render(from input: InvoiceInput) -> Data
}

class CommonInvoiceRenderer: InvoiceRenderable {

    let textColor: UIColor
    let tableBorderColor: UIColor
    let headersFillColor: UIColor

    init(
        textColor: UIColor = .black,
        tableBorderColor: UIColor = .black,
        headersFillColor: UIColor = .systemGray6
    ) {
        self.textColor = textColor
        self.tableBorderColor = tableBorderColor
        self.headersFillColor = headersFillColor
    }

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
            textColor: textColor,
            tableBorderColor: tableBorderColor,
            headersFillColor: headersFillColor
        )

        return renderer.render()
    }
}
