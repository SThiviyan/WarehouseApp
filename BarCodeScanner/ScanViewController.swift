//
//  ViewController.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 10.03.25.
//

import UIKit
import AVFoundation
import Vision

class ScanViewController: UIViewController {

    var captureSession: AVCaptureSession!
    
    var backCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup_start_captureSession()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    func setup_start_captureSession()
    {
        DispatchQueue.global(qos: .userInitiated).async {
            
            
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            
            
            if self.captureSession.canSetSessionPreset(.hd4K3840x2160)
            {
                self.captureSession.sessionPreset = .hd4K3840x2160
            }
            else
            {
                self.captureSession.sessionPreset = .hd1920x1080
            }
            
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            
            self.setupInputs()
            
            DispatchQueue.main.async
            {
                self.camerapreviewlayer()
            }
            
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
            
        }
    }
    
    
    func setupInputs()
    {
        var realdevice = false
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        {
            backCamera = device
            realdevice = true
        }
        else
        {
            print("no back cam, or Simulator device")
        }
        
        if(realdevice == true)
        {
            guard let Input = try? AVCaptureDeviceInput(device: backCamera) else
            {
                fatalError("could not create input device")
            }
            backInput = Input
            
            captureSession.addInput(backInput)
        }
    }
    
    
    func camerapreviewlayer()
    {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.insertSublayer(previewLayer, below: navigationController?.navigationBar.layer)
        previewLayer.frame = self.view.layer.frame
    }

}

