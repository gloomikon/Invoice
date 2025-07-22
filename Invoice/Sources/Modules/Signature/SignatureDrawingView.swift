import PencilKit
import SwiftUI

struct SignatureDrawingView: UIViewRepresentable {

    @Binding var clearTrigger: Bool
    @Binding var generateImageTrigger: Bool
    @Binding var hasSignature: Bool

    var generateImageHandler: ((_ signatureImage: UIImage) -> Void)?

    class Coordinator: NSObject, PKCanvasViewDelegate {

        var parent: SignatureDrawingView
        var canvas: PKCanvasView?

        init(parent: SignatureDrawingView) {
            self.parent = parent
        }

        func captureImage() {
            guard let canvas = canvas else { return }

            let renderer = UIGraphicsImageRenderer(bounds: canvas.bounds)
            let image = renderer.image { _ in
                canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: true)
            }
            parent.generateImageHandler?(image)
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.hasSignature = !canvasView.drawing.strokes.isEmpty
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        context.coordinator.canvas = canvas

        canvas.delegate = context.coordinator
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: .black, width: 3)
        canvas.backgroundColor = .white

        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        if clearTrigger {
            DispatchQueue.main.async {
                canvas.drawing = PKDrawing()
                clearTrigger = false
            }
        }

        if generateImageTrigger {
            DispatchQueue.main.async {
                context.coordinator.captureImage()
                generateImageTrigger = false
            }
        }
    }
}
