import UIKit

struct QRCodeGenerator {

    let encodable: String
    let fillColor: UIColor
    let size: CGSize

    var image: UIImage? {
        let data = encodable.data(using: String.Encoding.ascii)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")

        guard
            let image = filter.outputImage,
            let colorFilter = CIFilter(name: "CIFalseColor")
        else {
            return nil
        }

        colorFilter.setValue(image, forKey: "inputImage")
        colorFilter.setValue(CIColor(color: fillColor), forKey: "inputColor0") // QR code color
        colorFilter.setValue(CIColor(color: .clear), forKey: "inputColor1") // Background color

        guard let coloredImage = colorFilter.outputImage else { return nil }

        let scaleX = size.width / coloredImage.extent.size.width
        let scaleY = size.height / coloredImage.extent.size.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let scaledImage = coloredImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
