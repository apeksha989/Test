//
//  CameraController.swift
//  AV Foundation
//
//  Created by Pranjal Satija on 29/5/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import AVKit
import UIKit
import FirebaseMLVision
import FirebaseMLModelInterpreter

private var vision = Vision.vision()
private var textRecognizer = vision.onDeviceTextRecognizer()

extension RealtimeCaptureController:AVCaptureVideoDataOutputSampleBufferDelegate{
  
  func setUpAVCapture() {
    session.sessionPreset = AVCaptureSession.Preset.vga640x480
    guard let device = AVCaptureDevice
      .default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
               for: .video,
               position: AVCaptureDevice.Position.back) else {
                return
    }
    captureDevice = device
    beginSession()
  }
  
  // Function to setup the beginning of the capture session
  func beginSession(){
    var deviceInput: AVCaptureDeviceInput!
    
    do {
      deviceInput = try AVCaptureDeviceInput(device: captureDevice)
      guard deviceInput != nil else {
        print("error: cant get deviceInput")
        return
      }
      
      if self.session.canAddInput(deviceInput){
        self.session.addInput(deviceInput)
      }
      
      videoDataOutput = AVCaptureVideoDataOutput()
      videoDataOutput.alwaysDiscardsLateVideoFrames=true
      videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
      videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue)
      
      if session.canAddOutput(self.videoDataOutput){
        session.addOutput(self.videoDataOutput)
      }
      
      videoDataOutput.connection(with: .video)?.isEnabled = true
      
      previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
      previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
      
      let rootLayer :CALayer = self.capturePreview.layer
      rootLayer.masksToBounds=true
      
      rootLayer.addSublayer(self.previewLayer)
      captureDevice.configureDesiredFrameRate(0.25)
      session.startRunning()
    } catch let error as NSError {
      deviceInput = nil
      print("error: \(error.localizedDescription)")
    }
  }
  
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    connection.videoOrientation = AVCaptureVideoOrientation.portrait
        
    if boolFlag == false{

      guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
      let ciImage = CIImage(cvPixelBuffer: imageBuffer)
      guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }

      let img = UIImage(cgImage: cgImage)
      guard let n = img.fixedOrientation() else { return }
      let image = VisionImage(image: n)
      boolFlag = true
      textRecognizer.process(image) { result, error in
        guard error == nil, let result = result else {
           self.beforChangedValue(circleView: self.checkCirclerBtn)
          self.boolFlag = false
          return
        }
        let resultText = result.text
        let matched = self.matches(for: RegEx.wholeRegex , in: resultText)
        let m = matched.joined(separator: "")
        self.boolFlag = false
        self.processingText(currencyValues: m)
      }
    }
  }
  func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
  }
  
  func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage? {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
    let ciImage = CIImage(cvPixelBuffer: imageBuffer)
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
    
    let img = UIImage(cgImage: cgImage)
    let n = img.fixedOrientation()
    return n
  }
}

