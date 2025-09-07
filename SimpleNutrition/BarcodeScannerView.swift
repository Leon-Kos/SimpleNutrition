//
//  BarcodeScannerView.swift
//  SimpleNutrition
//
//


import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var scannedCode: String? // Hier speichern wir das Ergebnis

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: BarcodeScannerView

        init(parent: BarcodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {
            if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               let code = metadata.stringValue {
                DispatchQueue.main.async {
                    self.parent.scannedCode = code
                    self.parent.presentationMode.wrappedValue.dismiss() // Scanner schließen
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let session = AVCaptureSession()

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else { return viewController }

        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        session.addOutput(output)

        output.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.ean8, .ean13, .qr, .code128] // Barcode-Typen

        // Vorschau Layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = viewController.view.layer.bounds
        viewController.view.layer.addSublayer(previewLayer)

        session.startRunning()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
