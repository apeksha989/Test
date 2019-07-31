


import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate{
    
    var captureSesssion : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    let capture = UIButtonFactory(title: "")
        .setBackgroundImage(image: "btn_capture")
        .addTarget(self, action: #selector(clicked), for: .touchUpInside)
        .build()
    
    let back = UIButtonFactory(title: "")
        .setBackgroundImage(image: "BackBtn")
        .addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        .build()
    
    let gallery = UIButtonFactory(title: "")
        .setBackgroundImage(image: "Gallery")
        .addTarget(self, action: #selector(galleryBtnTapped), for: .touchUpInside)
        .build()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         debugPrint("<---------CameraController------------>😀")
        gallery.layer.cornerRadius = gallery.frame.height / 2
        gallery.layer.masksToBounds = true
      
      if let imagesArray = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "WalletDocImageArray") as? [UIImage] {
        UserDetails.imageArray = imagesArray
      }
      if let datesArray = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "WalletDocDateArray") as? [String] {
        UserDetails.dateArray = datesArray
      }
      
        
        if !UserDetails.imageArray.isEmpty{
            UIView.animate(withDuration: 1, delay: 0.7, options: .curveEaseOut, animations: {
                let lastImage = UserDetails.imageArray.last
                self.gallery.setImage(lastImage, for: .normal)
            }, completion: nil)
        }
      
        askPermission()
        captureSesssion = AVCaptureSession()
        captureSesssion.sessionPreset = AVCaptureSession.Preset.vga640x480
        cameraOutput = AVCapturePhotoOutput()
        
        guard let device = AVCaptureDevice
            .default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                     for: .video,
                     position: AVCaptureDevice.Position.back) else {
                        return
        }
        
        if let input = try? AVCaptureDeviceInput(device: device) {
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(cameraOutput)) {
                    captureSesssion.addOutput(cameraOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    previewLayer.frame = view.bounds
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    view.layer.addSublayer(previewLayer)
                    captureSesssion.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
        view.addSubview(capture)
        view.addSubview(back)
        view.addSubview(gallery)
        view.bringSubviewToFront(gallery)
        view.bringSubviewToFront(back)
        view.bringSubviewToFront(capture)
        
        back.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        
        gallery.layoutAnchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 50, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        
        capture.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 50, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.view.layer.bounds
    }
    
    
    @objc func backBtnTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func galleryBtnTapped(){
        popOrPushToViewController("WalletDocumentsController")
    }
    
    @objc func clicked(){
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
        
        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(UIImage(data: dataImage)?.size as Any)
            
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
            let imageFixRotation = fixOrientation(img: image)
            UIView.animate(withDuration: 1, delay: 0.7, options: .curveEaseOut, animations: {
                self.gallery.setImage(imageFixRotation, for: .normal)
            }, completion: nil)
            let datevalue = dataValue()
            _ = [imageFixRotation:"\(datevalue)"]
            
            UserDetails.imageArray.append(imageFixRotation)
            UserDetails.dateArray.append(datevalue)
            
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.imageArray, storeType: "WalletDocImageArray")
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.dateArray, storeType: "WalletDocDateArray")
               
        } else {
            print("some error here")
        }
    }
    
    func askPermission() {
        print("here")
        let cameraPermissionStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraPermissionStatus {
        case .authorized:
            print("Already Authorized")
        case .denied:
            print("denied")
            
            let alert = UIAlertController(title: "Sorry :(" , message: "But  could you please grant permission for camera within device settings",  preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel,  handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        case .restricted:
            print("restricted")
        default:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                [weak self]
                (granted :Bool) -> Void in
                if granted == true {
                    DispatchQueue.main.async(){
                        //Do smth that you need in main thread
                    }
                }
                else {
                    DispatchQueue.main.async(){
                        let alert = UIAlertController(title: "WHY?" , message:  "Camera it is the main feature of our application", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            self?.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            });
        }
    }
}

extension CameraController{
    func dataValue()-> String{
        let currentDate = Date()
        var first : String?
        var second : String?
        var full : String?
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.string(from: currentDate)
        first = date
        dateFormatter.dateFormat = "HH:mm"
        let date1 = dateFormatter.string(from: currentDate)
        second = date1
        full = "\(first!), \(second!)"
        return (full ?? "")
    }
    
}
