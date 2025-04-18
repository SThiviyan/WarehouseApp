//
//  ViewController.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 10.03.25.
//



import UIKit
import AVFoundation
import Vision
import SwiftUI

class ScanViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    //MARK: All variables for Camera and Vision
    var captureSession: AVCaptureSession!
    
    var backCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    var cameraOutput = AVCaptureVideoDataOutput()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
            
    
    private let visionQueue = DispatchQueue(label: "visionQueue")
    private var framecounter = 0 //Throttle processing
    
    var currentAddView: AddView? = nil
    var openedViaAddView: Bool = false
    
    //MARK: UI Elements
    let FlashButton: UIButton =
    {
        let Button = UIButton()
        
        
        Button.clipsToBounds = true
        Button.contentMode = .center
       
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.layer.cornerRadius = 35
        Button.layer.cornerCurve = .continuous
        Button.backgroundColor = .tertiarySystemFill
        
        let image = UIImageView(image: UIImage(systemName: "flashlight.off.fill"))
        Button.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: Button.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: Button.centerYAnchor),
            image.heightAnchor.constraint(equalTo: Button.heightAnchor, multiplier: 0.6),
            image.widthAnchor.constraint(equalTo: Button.widthAnchor, multiplier: 0.4)
        ])
        
        return Button
    }()
    
    
    var flashOn = false
    
    
    
    //MARK: LIFECYClE OF VIEWCONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //MARK: Only for development, to see in simulator
        let text = UILabel()
        text.text = "Scan BarCode"
        view.addSubview(text)
        
        setup_start_captureSession()
        addButton()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let previewLayer = previewLayer
        {
            previewLayer.frame = view.bounds
        }
    }
    
   
  
    
    //MARK: Setup of the AVCaptureSession, to enable live feed
    func setup_start_captureSession()
    {
    
         DispatchQueue.global(qos: .userInitiated).async {
            
            
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            
            
            if self.captureSession.canSetSessionPreset(.hd1280x720)
            {
                self.captureSession.sessionPreset = .hd1280x720
            }
            else
            {
                self.captureSession.sessionPreset = .iFrame960x540
            }
            
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            self.setupInputs()
            self.setupOutputs()
            
            self.captureSession.commitConfiguration()

            
            
            self.captureSession.startRunning()

            
        }
        
        DispatchQueue.main.async
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
            {
                self.camerapreviewlayer()
            }
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
            
            //TODO: Authorization Request has to be done again!
            
            
            guard let Input = try? AVCaptureDeviceInput(device: backCamera) else
            {
                if(AVCaptureDevice.authorizationStatus(for: .video) != AVAuthorizationStatus.authorized){
                    
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: {(granted: Bool) in
                        if granted {
                            DispatchQueue.main.async
                            {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                                {
                                    self.camerapreviewlayer()
                                }
                            }
                        }
                        else{
                            
                            print("no camera")
                        }
                        
                    })
                    
                }
                //fatalError("could not create input device")
                
                return
            }
            backInput = Input
            
            if captureSession.canAddInput(backInput)
            {
                captureSession.addInput(backInput)
            }
        }
    }
    
    
    func setupOutputs()
    {
        cameraOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        cameraOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(cameraOutput)
        {
            captureSession.addOutput(cameraOutput)
        }
    }
    
    func camerapreviewlayer()
    {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        print("previewView is nil? \(previewLayer == nil)")
        print("view is nil? \(view == nil)")
        print("captureSession is nil? \(captureSession == nil)")
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = self.view.layer.bounds

        view.layer.insertSublayer(previewLayer, at: 0)
       
        
        
        view.bringSubviewToFront(FlashButton)
    }

    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer:
                       CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        framecounter += 1
        if framecounter % 10 != 0 { return }
        
        guard let pixelbuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else
        {return}
        
        detectBarcode(pixelBuffer: pixelbuffer)
        
    }
    
    func detectBarcode(pixelBuffer: CVPixelBuffer)
    {
        
        let request = VNDetectBarcodesRequest(completionHandler: {
            (request, error) in
            
            if let results = request.results as? [VNBarcodeObservation]
                {
                    for barcode in results
                    {
                        if let payload = barcode.payloadStringValue
                        {
                            DispatchQueue.main.async
                            {
                                //self.captureSession.stopRunning()
                                
                                
                                //self.showBarcodeAlert(payload: payload)
                                if(self.openedViaAddView)
                                {
                                    self.dismiss(animated: true, completion: {
                                        self.currentAddView?.product?.barcode = payload
                                        self.openedViaAddView = false
                                        self.currentAddView?.productscanned = true
                                        
                                        print(payload)
                                        self.currentAddView = nil
                                    })
                                }
                                else
                                {
                                    self.BarcodeDetected(payload: payload)
                                }
                            }
                        }
                    }
                }
            
        })
        
        
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do
            {
                try handler.perform([request])
            }
            catch
            {
                print("barcode detection failed")
            }
        }
    
    
    
    func showBarcodeAlert(payload: String)
    {
        let alert = UIAlertController(title: "Barcode detected", message: payload, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
            self.captureSession.startRunning()
            
        }))
        present(alert, animated: true, completion: {
            return
        })
    }
    
    func BarcodeDetected(payload: String)
    {
        
        
        
        if(App.shared.getProduct(payload) == nil)
        {
            let product = Product(barcode: payload)
            
            let hostingController = UIHostingController(rootView: AddView(product: product))
            present(hostingController, animated: true)
        }
        else{
            
            
            let product = App.shared.getProduct(payload)!
            let hostingController = UIHostingController(rootView: LookUpView(product: product))
            
            present(hostingController, animated: true)
        }
        
        
        /*
        DispatchQueue.main.async(execute: {
            self.captureSession.startRunning()
        })
         */
    }
    
}



extension ScanViewController
{
    func addButton()
    {
        view.addSubview(FlashButton)
        FlashButton.addTarget(self, action: #selector(buttonPressed), for: [ .touchDown, .touchDragEnter])
        FlashButton.addTarget(self, action: #selector(buttonReleased), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        
        NSLayoutConstraint.activate([
            //FlashButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //FlashButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            FlashButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            FlashButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            FlashButton.widthAnchor.constraint(equalToConstant: 70),
            FlashButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    
    @objc func buttonPressed(sender: UIButton)
    {
        flashOn.toggle()
        
        animate(sender, transform: .identity)
        
        if(flashOn)
        {
            do{
                if(backCamera.hasTorch)
                {
                    try backCamera.lockForConfiguration()
                    backCamera.torchMode = .on
                    backCamera.unlockForConfiguration()
                }
                
                
            }
            catch
            {
                print("Device flash Error")
            }
        }
        else
        {
            do
            {
                if(backCamera.hasTorch)
                {
                    try backCamera.lockForConfiguration()
                    backCamera.torchMode = .off
                    backCamera.unlockForConfiguration()
                }
            }
            catch
            {
                print("Device torch flash Error")
            }
        }
    }
    
    @objc func buttonReleased(sender: UIButton)
    {
        animate(sender, transform: .identity)
    }
    
    
    //TODO: ANIMATION FOR FLASH BUTTON
    private func animate(_ button: UIButton, transform: CGAffineTransform)
    {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, animations: {
            button.transform = transform
        }, completion: nil)
    }
    
    
    
}



