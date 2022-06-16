//
//  CameraPreviewHelper.swift
//  Essi Stock
//
//  Created by Adrien Surugue on 15/06/2022.
//

import Foundation
import SwiftUI
import AVFoundation
import Vision

enum Camera: Error{
    case notSupported
}

struct CameraPreview: UIViewRepresentable{
    
    @Binding var showAlert: Bool
    let captureSession = AVCaptureSession()
    
    func makeUIView(context: Context) -> some UIView {
        
        var previewLayer = AVCaptureVideoPreviewLayer()
        let view = UIView(frame: UIScreen.main.bounds)
        
        view.backgroundColor = UIColor.black
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.connection?.videoOrientation = .landscapeLeft
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        
        context.coordinator.session = captureSession
        
        Task{
            do{
                try context.coordinator.openSession(session: captureSession)
                context.coordinator.metaOutput()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    captureSession.startRunning()
                })
            } catch Camera.notSupported {
                showAlert = true
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    // MARK: - Camera Preview Coordinator
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate{
        
        var photoOutput = AVCapturePhotoOutput()
        var session: AVCaptureSession?
        var parent: CameraPreview
        
        init(parent: CameraPreview){
            self.parent = parent
        }
        
        // MARK: - Open capture session
        func openSession(session: AVCaptureSession)throws{
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video)else{throw Camera.notSupported}
            let videoInput: AVCaptureDeviceInput
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                
            } catch {return}
            photoOutput = AVCapturePhotoOutput()
            if  session.canAddInput(videoInput) && session.canAddOutput(photoOutput){
                session.addInput(videoInput)
                session.addOutput(photoOutput)
            }else{return}
        }
        
        // MARK: - Detect barcode, QRcode
        func metaOutput(){
            let metadataOutput = AVCaptureMetadataOutput()
            if (session!.canAddOutput(metadataOutput)) {
                session!.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr, .interleaved2of5, .dataMatrix, .code128, .code39, .code93, .ean13]
            }else{return}
        }
        
        // MARK: - Decoding barcode, QRcode
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
                guard let stringValue = readableObject.stringValue
                else{return}
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                print(stringValue)
                session!.stopRunning()
            }
        }
        
    }
}
