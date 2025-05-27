import Foundation

protocol InvoiceRenderable {

    func render(from input: InvoiceInput) -> Data
}

class CommonInvoiceRenderer: InvoiceRenderable {

    func render(from input: InvoiceInput) -> Data {
        Data()
    }
}
