//
//  RealtimeCaptureController.swift
//  Haggle
//
//  Created by Anil Kumar on 22/02/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import FirebaseMLVision
import FirebaseMLModelInterpreter
import PassKit
import Stripe

var scanFlag = false

class RealtimeCaptureController: UIViewController {
  
  @IBOutlet weak var customNavigationBar: UIView!
  @IBOutlet weak var pop:                 UIView!
  @IBOutlet weak var reticle:             UIView!
  @IBOutlet var capturePreview:           UIView!
  @IBOutlet weak var currency:            UILabel!
  @IBOutlet weak var convertion:          UILabel!
  @IBOutlet weak var closebtm:            UIButton!
  @IBOutlet weak var messageLabel:        UILabel!
  @IBOutlet weak var cameraOverlay:       UIImageView!
  @IBOutlet weak var buyCurrency:         UILabel!
  @IBOutlet weak var reticleGreen:        UIView!
  @IBOutlet weak var applePayImage: UIImageView!
  
//  var toastLabel = UILabel()
  
  //    private lazy var applePayment = ApplePay()
  var rect =                 CGRect()
  var vision =               Vision.vision()
  let pulsator =             Pulsator()
  var videoDataOutput =      AVCaptureVideoDataOutput()
  var videoDataOutputQueue:  DispatchQueue!
  var previewLayer:          AVCaptureVideoPreviewLayer!
  var captureDevice :        AVCaptureDevice!
  var session =              AVCaptureSession()
  var context =              CIContext()
  var mergedCurrencyValues = String()
  var currencyFilter =       String()
  var homeCurrencyCode   = String()
  var showPopUpFlag =        Bool()
  var boolFlagSet =          Bool()
  var GreenFlag2 =           false
  var boolTextDetectFlag1 =  false
  var toastFlag =            false
  var toastFlag1 =           false
  var boolTextDetectFlag =   false
  var arr  : [String] =      []
  var kMaxRadius: CGFloat =  80
  var kMaxDuration: TimeInterval = 10
  var pulsatorFlag =         false
  var animationFlag =        false
  var textFlag = false
  var falseCount : [Int] = []
  var constFlag = false
  var countryCode = String()
  var countryCodeName = String()
  var applePayCurrency = String()
  var applePayCurrencyName = String()
  var timer = Timer()
  var timerFlag = false
  var scannedCode = String()
  var convertedCode = String()
    
    let value = RegExpression.shared.codeToSymbole.map {($0.value)}
    let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
  //============================================================================
  //MARK: viewDidLoad
  //============================================================================
  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------RealtimeCaptureController------------>😀")
    let gusture = UITapGestureRecognizer(target: self, action: #selector(applePayClicked))
    applePayImage.isUserInteractionEnabled = true
    applePayImage.addGestureRecognizer(gusture)
    ApplePayController.sharedInstance.delegate = self
    pop.isHidden = true
    rect = CGRect(x: self.cameraOverlay.frame.origin.x + 70, y: self.cameraOverlay.frame.origin.y + 50, width: self.cameraOverlay.frame.width , height: self.cameraOverlay.frame.height)
    setUpAVCapture()
  }
  
  //============================================================================
  //MARK: viewWillAppear
  //============================================================================
  
  override func viewWillAppear(_ animated: Bool) {
    timerFlag = false
    toastFlag1 = false
    timer.invalidate()
    pop.isHidden = true
    self.setTimer()
//    searchCountryFlag = false
//    StrongBoxController.sharedInstance.storeUserDefault(data: searchCountryFlag, storeType: "searchCountryFlag")
    countryCode = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationCode") as! String
    countryCodeName = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationName") as! String
    navigationController?.setNavigationBarHidden(true, animated: animated)
    view.addSubview(customNavigationBar)
    view.bringSubviewToFront(customNavigationBar)
    view.addSubview(reticle)
    view.bringSubviewToFront(reticle)
    
    self.view.addSubview(cameraOverlay!)
    self.view.bringSubviewToFront(cameraOverlay!)
    let str = "Incorrect amount? Enter Manually"
    let trimmedString = str.trimmingCharacters(in: .whitespacesAndNewlines)
    let string = NSMutableAttributedString(string: trimmedString)
    string.setColorForText("Enter Manually", with: #colorLiteral(red: 0.9882352941, green: 0.4196078431, blue: 0.2235294118, alpha: 1))
    messageLabel.attributedText = string
    pulsatorFlag = false
    start()
    buyCurrency.text = "Rates displayed are indicative only and are subject to change."
    buyCurrency.numberOfLines = 3
    buyCurrency.adjustsFontSizeToFitWidth = true
    reticle.layer.cornerRadius = reticle.frame.height/2
    
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.enterManuallyTapped(_:)))
    messageLabel.addGestureRecognizer(tap)
    messageLabel.isUserInteractionEnabled = true
    
    currency.adjustsFontSizeToFitWidth = true
    convertion.adjustsFontSizeToFitWidth = true
    
    NotificationCenter.default.addObserver(self, selector: #selector(backButtonTapped(_:)), name: .BackButtonTapped, object: nil)
    
  }
  
  //============================================================================
  //MARK: viewWillDisappear
  //============================================================================
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
//    session.stopRunning()
//    stop()
//    ApplePayController.destroy()
  }
  
  //============================================================================
  //MARK: viewDidLayoutSubviews
  //============================================================================
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    previewLayer.frame = self.capturePreview.layer.bounds
    view.layer.layoutIfNeeded()
    pulsator.position = reticle.layer.position
  }
  
  // function which is triggered when enterManuallyTapped is called
  @objc func enterManuallyTapped(_ sender: UITapGestureRecognizer) {
    stop()
    session.stopRunning()
    popOrPushToViewController("ManualInputController")
  }
  
  // function which is triggered when backButtonTapped is called
  @objc func backButtonTapped(_ notification: Notification)
  {
    timerFlag = false
    toastFlag1 = false
    timer.invalidate()
    self.setTimer()
    viewSendBack()
    UserDetails.ClickBool.clicked = true
    start()
    session.startRunning()
  }
  
  // function bring the popup
  func viewBringSubView(){
    view.bringSubviewToFront(self.pop)
  }
  func viewSendBack(){
    view.sendSubviewToBack(pop)
  }
  
  //MARK: deinit
  
  deinit {
    deallocSession()
    print("Memery Leak RealtimeCaptureController")
  }
  
  @IBAction func tripCurrencyTapped(_ sender: Any) {
    stop()
    session.stopRunning()
    UserDetails.ClickBool.clicked = false
    presentDissmiss(controller: "CountryViewController")
  }
  
  
  @IBAction func navigationBackButton(_ sender: Any) {
    lensFlag = true
    session.stopRunning()
    stop()
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func clearBtn(_ sender: Any) {
    timerFlag = false
    toastFlag1 = false
    timer.invalidate()
    self.setTimer()
    pulsatorFlag = false
    start()
    self.pop.isHidden = true
    self.showPopUpFlag = false
    self.mergedCurrencyValues = ""
    self.currency.text = ""
    self.viewSendBack()
    self.boolFlagSet = false
  }
  
  @IBAction func haggleClicked(_ sender: Any) {
    session.stopRunning()
    stop()
    popOrPushToViewController("HaggleMainScreen")
  }
  
}

extension RealtimeCaptureController{
  
  func getResult(resultText: String,currency : String,completionHandler: @escaping ( _ success: Bool,_ error : String) -> Void){
    let getCurrencyValue = self.matches(for: RegExpression.shared.wholeRegex , in: resultText) //reuyfgaiufgae€11,12.22sfdgiyaidyfg
    mergedCurrencyValues = getCurrencyValue.joined(separator: "")
    let currencySymbol = self.matches(for: RegExpression.shared.symbolRegex, in: mergedCurrencyValues)
    let currencyValues = self.matches(for: RegExpression.shared.NumberRegex, in: mergedCurrencyValues)
    let currencyCodes = self.matches(for: RegExpression.shared.CodesRegex, in: mergedCurrencyValues)
    
    var JoinedCurrencyValue  =  currencyValues.joined(separator: "")
    
    var JoinedCurrencySymbole  =  currencySymbol.joined(separator: "")
    var JoinedCurrencyCode  =  currencyCodes.joined(separator: "")
    JoinedCurrencySymbole = removeDotCommas(Values: JoinedCurrencySymbole)
    JoinedCurrencyCode = removeDotCommas(Values: JoinedCurrencyCode)
    var checkingLastChar = String(JoinedCurrencyValue.suffix(3))
    let checkingLastCharArray = Array(checkingLastChar)
    
    if !checkingLastCharArray.isEmpty{
      if (checkingLastCharArray[0] == ".")||(checkingLastCharArray[0] == ","){
        JoinedCurrencyValue = String(JoinedCurrencyValue.dropLast(3))
        JoinedCurrencyValue = removeDotCommas(Values: JoinedCurrencyValue)
        checkingLastChar = removeDotCommas(Values: checkingLastChar)
        let DigitValue = self.matches(for: RegExpression.shared.decimalLastDigits, in: checkingLastChar)
        if !DigitValue.isEmpty{
          JoinedCurrencyValue = JoinedCurrencyValue + ".\(DigitValue[0])"
          self.parseCurrency(CurrencyWithValue: mergedCurrencyValues, Symbol: JoinedCurrencySymbole, currencyCode: JoinedCurrencyCode, values: JoinedCurrencyValue) { (success,error) in
            if success == true{
              completionHandler(true,"")
            }else{
              completionHandler(false,error)
            }
          }
        }
      }else{
        JoinedCurrencyValue = removeDotCommas(Values: JoinedCurrencyValue)
        self.parseCurrency(CurrencyWithValue: mergedCurrencyValues, Symbol: JoinedCurrencySymbole, currencyCode: JoinedCurrencyCode, values: JoinedCurrencyValue) { (success,error) in
          if success == true{
            completionHandler(true,"")
          }else{
            completionHandler(false,error)
          }
        }
      }
    }
  }
  
  func parseCurrency(CurrencyWithValue: String,Symbol: String,currencyCode: String,values: String, completionHandler: @escaping ( _ success: Bool,_ error : String) -> Void){
    // let symbole = getSymbolForCurrencyCode(code: countryCode)
    if UserDetails.ChangeHomeCurrency.homeCurrencyCode == ""{
      let key = RegExpression.shared.currencysymbols.map {($0.key)}
      let value = RegExpression.shared.currencysymbols.map {($0.value)}
      
      homeCurrencyCode = countryCode
      let homeSymbol   = getSymbolForCurrencyCode(code: countryCode)
      
      for i in 0..<(key.count) where key[i] == Symbol{
        if homeSymbol == Symbol{
          UserDetails.haggleTargetCode = countryCode
          UserDetails.TargetCurrency.targetCurrencyCode = countryCode
        }else{
          UserDetails.TargetCurrency.targetCurrencyCode = value[i]
          UserDetails.haggleTargetCode = value[i]
        }
      }
      print(UserDetails.TargetCurrency.targetCurrencyCode)
      requestData()
      if CurrencyWithValue.contains(Symbol){
        
        scannedCode = countryCode
        
        currency.text = "\(Symbol)\(values)"
        UserDetails.PercentageCalculation.code = countryCode
        UserDetails.haggleTargetCode = UserDetails.TargetCurrency.targetCurrencyCode
        UserDetails.haggleHomeCode   = countryCode
        requestData()
        dynamicCurrencys(basecurrency: UserDetails.TargetCurrency.targetCurrencyCode, target: countryCode, value: values) { (success,error)  in
          if success == true{
            completionHandler(true,"")
          }else{
            completionHandler(false,error)
          }
        }
      }else if CurrencyWithValue.contains(currencyCode){
        var CurrencySymbol = getSymbolForCurrencyCode(code: currencyCode)
        
        
        for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == currencyCode{
          CurrencySymbol = value[i]
        }
         scannedCode = currencyCode
        currency.text = "\(CurrencySymbol)\(values)"
        UserDetails.PercentageCalculation.code = currencyCode
        UserDetails.haggleTargetCode = currencyCode
        UserDetails.haggleHomeCode = countryCode
        requestData()
        dynamicCurrencys(basecurrency: currencyCode, target: countryCode, value: values) { (success,error) in
          if success == true{
            completionHandler(true,"")
          }else{
            completionHandler(false,error)
          }
        }
      }else{
        if countryCode.isEmpty{
          showConfirmAlert(title: "", message: "Make sure your location is disabled please enable the location!", buttonTitle: "Ok", buttonStyle: .default) { [weak self](action) in
            self?.navigationController?.popToRootViewController(animated: true)
          }
        }else{
          var CurrencySymbol = getSymbolForCurrencyCode(code: countryCode)
          
          
          let value = RegExpression.shared.codeToSymbole.map {($0.value)}
          let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}

          for i in 0..<(value.count) where value[i] == countryCode{
            CurrencySymbol = symboleGetArray[i]
          }
          scannedCode = countryCode
          currency.text =  CurrencySymbol + values
          UserDetails.PercentageCalculation.code = countryCode
          UserDetails.haggleHomeCode = countryCode
          UserDetails.haggleTargetCode = countryCode
          requestData()
          dynamicCurrencys(basecurrency: UserDetails.haggleHomeCode, target: UserDetails.haggleTargetCode, value: values) { (success,error) in
            if success == true{
              completionHandler(true,"")
            }else{
              completionHandler(false,error)
            }
          }
        }
      }
    }else{
      let key = RegExpression.shared.currencysymbols.map {($0.key)}
      let value = RegExpression.shared.currencysymbols.map {($0.value)}
      
      homeCurrencyCode = UserDetails.ChangeHomeCurrency.homeCurrencyCode
      
      for i in 0..<(key.count) where key[i] == Symbol{
        UserDetails.TargetCurrency.targetCurrencyCode = value[i]
        UserDetails.haggleTargetCode = value[i]
      }
      if CurrencyWithValue.contains(Symbol){
        scannedCode = countryCode
        currency.text = Symbol + values
        UserDetails.PercentageCalculation.code = countryCode
        UserDetails.haggleTargetCode = UserDetails.TargetCurrency.targetCurrencyCode
        requestData()
        dynamicCurrencys(basecurrency: UserDetails.TargetCurrency.targetCurrencyCode, target: UserDetails.ChangeHomeCurrency.homeCurrencyCode, value: values, completionHandler: { (succesDynamic, error) in
          if succesDynamic{
            completionHandler(true,"")
          }else{
            completionHandler(false,"")
          }
        })
      }else if CurrencyWithValue.contains(currencyCode){
        var CurrencySymbol = getSymbolForCurrencyCode(code: currencyCode)

        for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == currencyCode{
          CurrencySymbol = value[i]
        }
        scannedCode = currencyCode
        currency.text = CurrencySymbol + values
        UserDetails.PercentageCalculation.code = currencyCode
        UserDetails.haggleTargetCode = currencyCode
        requestData()
        dynamicCurrencys(basecurrency: currencyCode, target: UserDetails.ChangeHomeCurrency.homeCurrencyCode, value: values, completionHandler: { (succesDynamic, error) in
          if succesDynamic{
            completionHandler(true,"")
          }else{
            completionHandler(false,"")
          }
        })
      }else{
        if countryCode.isEmpty{
          showConfirmAlert(title: "", message: "Make sure your location is disabled please enable the location!", buttonTitle: "Ok", buttonStyle: .default) { [weak self](action) in
            self?.navigationController?.popToRootViewController(animated: true)
          }
        }else{
          var locationCode = getSymbolForCurrencyCode(code: countryCode)
          
          let value = RegExpression.shared.codeToSymbole.map {($0.value)}
          let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}

          for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == countryCode{
            locationCode = value[i]
          }
          scannedCode = countryCode
          currency.text = locationCode + values
          UserDetails.PercentageCalculation.code = countryCode
          UserDetails.haggleTargetCode = countryCode
          requestData()
          dynamicCurrencys(basecurrency: countryCode, target: UserDetails.haggleHomeCode, value: values, completionHandler: { (succesDynamic, error) in
            if succesDynamic{
              completionHandler(true,"")
            }else{
              completionHandler(false,"")
            }
          })
        }
      }
    }
  }
}


extension RealtimeCaptureController{
  
  //============================================================================
  //MARK: Wallet Currency Convertion
  //============================================================================
  
  func dynamicCurrencys(basecurrency : String ,target : String, value : String,completionHandler: @escaping ( _ success: Bool, _ error: String) -> Void){
    Networking.sharedInstance.convertion(baseCurrency: basecurrency, targetCurrency: target, Value : value, completion: { [weak self] (success, error,convertedValue) in
      if success == true{
        
        if UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty {
            let cName = UserDetails.haggleHomeCode
            if let CountryName = UserDetails.countryAndCodeAndIcon["code"] {
                let CountryIcon = UserDetails.countryAndCodeAndIcon["icon"]
                for i in 0..<(CountryName.count) {
                    if cName == CountryName[i]{
                        print(CountryIcon![i])
                        UserDetails.haggleTargetIcon = CountryIcon![i]
                    }
                }
            }
          var symbole = self?.getSymbolForCurrencyCode(code: UserDetails.haggleHomeCode)
          
          let value = RegExpression.shared.codeToSymbole.map {($0.value)}
          let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}

          for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == UserDetails.haggleHomeCode{
            symbole = value[i]
          }
          
          self?.applePayCurrency = self!.countryCode
          self?.applePayCurrencyName = self!.countryCodeName
          self?.convertedCode = self!.countryCode
          self?.convertion.text = "\(symbole!)\(convertedValue)"
        }else{
            let cName = UserDetails.ChangeHomeCurrency.homeCurrencyCode
            if let CountryName = UserDetails.countryAndCodeAndIcon["code"] {
                let CountryIcon = UserDetails.countryAndCodeAndIcon["icon"]
                for i in 0..<(CountryName.count) {
                    if cName == CountryName[i]{
                        print(CountryIcon![i])
                        UserDetails.haggleTargetIcon = CountryIcon![i]
                    }
                }
            }
          self?.applePayCurrency = UserDetails.ChangeHomeCurrency.homeCurrencyCode
          self?.applePayCurrencyName = UserDetails.ChangeHomeCurrency.homeCurrencyName
          var symbol = self?.getSymbolForCurrencyCode(code: UserDetails.ChangeHomeCurrency.homeCurrencyCode)
          
          let value = RegExpression.shared.codeToSymbole.map {($0.value)}
          let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}

          for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == UserDetails.haggleHomeCode{
            symbol = value[i]
          }
          self?.convertedCode = UserDetails.haggleHomeCode
          self?.convertion.text = "\(symbol!)\(convertedValue)"
        }
        completionHandler(true,"")
      }else{
        completionHandler(false,error)
      }
    })
  }
}


//============================================================================
//MARK: Camera Controller functions
//============================================================================

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
      if session.canAddInput(deviceInput){
        session.addInput(deviceInput)
      }
      videoDataOutput = AVCaptureVideoDataOutput()
      videoDataOutput.alwaysDiscardsLateVideoFrames=true
      videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
      videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
      
      if session.canAddOutput(videoDataOutput){
        session.addOutput(videoDataOutput)
      }
      
      videoDataOutput.connection(with: .video)?.isEnabled = true
      
      previewLayer = AVCaptureVideoPreviewLayer(session: session)
      previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
      
      let rootLayer :CALayer = capturePreview.layer
      rootLayer.masksToBounds=true
      
      rootLayer.addSublayer(previewLayer)
      //captureDevice.configureDesiredFrameRate(0.25)
      
      session.startRunning()
    } catch let error as NSError {
      deviceInput = nil
      print("error: \(error.localizedDescription)")
    }
  }
  
  //============================================================================
  //MARK: Camera Delegate functions
  //============================================================================
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    connection.videoOrientation = AVCaptureVideoOrientation.portrait
    
    if boolTextDetectFlag == false{
      guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
      let ciImage = CIImage(cvPixelBuffer: imageBuffer)
      guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
      let img = UIImage(cgImage: cgImage)
      let fixedOrientation = fixOrientation(img: img)
      let imag = fixedOrientation.croppedInRect(rect: rect)
      let textRecognizer = vision.onDeviceTextRecognizer()
      let image = VisionImage(image: imag)
      boolTextDetectFlag = true
      textRecognizer.process(image) { [weak self] result, error in
        //   guard let self = self else { return }Changes made by Apeksha
        guard let `self` = self else { return }
        if error == nil {
          if self.GreenFlag2 == true{
            if result?.text == nil{
              self.pulsator.stop()
              self.pulsatorFlag = false
              self.start()
              self.GreenFlag2 = false
            }
          }else{
            if self.animationFlag == false{
              Toast.sharedInstance.hideToast()
              self.pulsatorFlag = true
              self.start()
              self.animationFlag = true
            }
          }
          self.boolTextDetectFlag = false
        }
        if let resultText = result?.text{
          if self.GreenFlag2 == false{
            self.pulsatorFlag = true
            guard let currencyMatched = self.matches(for: RegExpression.shared.wholeRegex , in: resultText) as? [String] else {return}
            self.currencyFilter = ""
            self.currencyFilter = currencyMatched.joined(separator: "")
            self.boolTextDetectFlag = false
            if self.animationFlag == false{
              self.start()
              self.animationFlag = true
            }
            self.getFilter(value: self.currencyFilter)
          }
        }else{
          self.animationFlag = false
          self.pulsatorFlag = false
          self.start()
        }
      }
    }
    else if boolTextDetectFlag1{
      boolTextDetectFlag = false
      boolTextDetectFlag1 = false
    }
  }
  
  //============================================================================
  //MARK: Camera touch to Focus
  //============================================================================
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let screenSize = cameraOverlay.bounds.size
    if let touchPoint = touches.first {
      let x = touchPoint.location(in: cameraOverlay).y / screenSize.height
      let y = 1.0 - touchPoint.location(in: cameraOverlay).x / screenSize.width
      let focusPoint = CGPoint(x: x, y: y)
      
      if let device = captureDevice {
        do {
          try device.lockForConfiguration()
          device.focusPointOfInterest = focusPoint
          //          device.focusMode = .continuousAutoFocus
          device.focusMode = .autoFocus
          //          device.focusMode = .locked
          device.exposurePointOfInterest = focusPoint
          device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
          device.unlockForConfiguration()
        }
        catch {
          // just ignore
        }
      }
    }
  }
}

//============================================================================
//MARK: Reticle Animation functions
//============================================================================

extension RealtimeCaptureController{
  
  func start(){
    UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: {
      self.reticle.alpha = 1
      self.view.sendSubviewToBack(self.reticleGreen)
      self.reticle.frame.size = CGSize(width: 35, height: 35)
      self.reticle.layer.cornerRadius = self.reticle.frame.height/2
      self.reticle.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
      self.reticle.layer.superlayer?.insertSublayer(self.pulsator, below: self.reticle.layer)
      self.setupPulse()
      if self.pulsatorFlag == true{
        self.pulsator.start()
      }else{
        self.pulsator.stop()
      }
    },completion: { _ in
    })
  }
  func stop(){
    pulsatorFlag = false
    GreenFlag2 = true
    animationFlag = false
    
    UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
      self.reticle.alpha = 0
      self.view.bringSubviewToFront(self.reticleGreen)
      self.reticleGreen.layer.cornerRadius = self.reticleGreen.frame.height/2
      self.reticleGreen.backgroundColor = UIColor.green
      self.pulsator.stop()
    },completion: { _ in
    })
  }
  func setupPulse(){
    pulsator.repeatCount = 100
    pulsator.numPulse = 3
    pulsator.radius = CGFloat(0.7) * kMaxRadius
    pulsator.animationDuration = Double(0.5) * kMaxDuration
    pulsator.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9).cgColor
  }
}

//============================================================================
//MARK: Accuracy level Currency Values
//============================================================================

extension RealtimeCaptureController {
  
  func getFilter(value: String){
    print(value)
//
//    if !value.isEmpty {
//      showToastLong()
//    }
    
    
    textFlag = true
    if value.isEmpty {
      // showToastLong()
      textFlag = true
//      Toast.hideToast()
    }
    if !value.isEmpty{
      self.arr.append(currencyFilter)

      if arr.count == 10 {
        //        if constFlag == true{
        //          Toast.hideToast()
        //          constFlag = false
        //        }else{
        showToast()
        //        }
        //        toastFlag1 = false
        let hasAllItemsEqual = arr.dropFirst().allSatisfy({ $0 == arr.first })
        if hasAllItemsEqual{
          popUpShow(resultText:arr.last!)
          boolTextDetectFlag = true
          textFlag = false
          boolTextDetectFlag1 = true
          print(hasAllItemsEqual)
        }else{
          falseCount.append(0+1)
          print("falsecountValue",falseCount)
        }
        currencyFilter = ""
        arr.removeAll()
      }
      if falseCount.count == 10{
        //        constFlag = true
        //        Toast.hideToast()
        //        toastFlag = true
        //        toastFlag1 = false
        //        showToastLong()
        //        falseCount.removeAll()
      }
    }
  }
}

//============================================================================
//MARK: Showing popup
//============================================================================

extension RealtimeCaptureController {
  func showToast(){
    if pop.isHidden{
      if toastFlag == false{
        toastFlag = true
        Toast.sharedInstance.removeLongToast()
        timerFlag = false
        toastFlag1 = false
        timer.invalidate()
        self.setTimer()
        Toast.sharedInstance.show(message: "Hold the camera steady close to the price until the circle turns green.", controller: self)
      }
    }
  }
  
  func showToastLong(){
    if pop.isHidden{
      if toastFlag1 == false{
        toastFlag1 = true
        scanFlag = false
        Toast.sharedInstance.hideToast()
        Toast.sharedInstance.showLongToast(message: "Hold the camera steady close to the price until the reticle turns green or You can Enter Manually.", controller: self)
      }
    }
  }
  func setTimer(){
    DispatchQueue.main.async {
      if self.pop.isHidden{
        if self.timerFlag == false{
          self.timerFlag = true
          self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.updateToast), userInfo: nil, repeats: true)
        }
      }
    }
  }
  
  
  @objc func updateToast(){
    showToastLong()
    self.timer.invalidate()
  }
  
  func popUpShow(resultText:String){
    debugPrint("<---------API Convertion Request CallBack------------>")
    
    self.getResult(resultText: resultText, currency: "") { (success, error) in
      if success {
        debugPrint("<---------API Success ------------>")
        if (self.currency.text != "" && self.convertion.text != ""){
          UserDetails.PercentageCalculation.ConvertedAmount = self.convertion.text!
          UserDetails.PercentageCalculation.scannedAmount = self.currency.text!
          StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.PercentageCalculation.scannedAmount, storeType: "PercentageCalculation.scannedAmount")
          StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.PercentageCalculation.ConvertedAmount, storeType: "PercentageCalculation.ConvertedAmount")
          
//          let ConvertionCurrencyArray = self.matches(for: RegExpression.shared.NumberRegex, in: self.convertion.text!)
//          let ScannedCurrencyArray = self.matches(for: RegExpression.shared.NumberRegex, in: self.currency.text!)
          
          let updateValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
          UserDetails.HomeSreenUpdateValues.updateValue(updateValues, forKey: "LensUpdate")
          StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
          
          NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
                    
          self.stop()
          self.viewBringSubView()
          scanFlag = true
          self.showPopUp()
        }
      }
    }
  }
  
  func showPopUp(){
    if showPopUpFlag == false{
      showPopUpFlag = true
      UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseIn], animations: {
        self.pop.layer.cornerRadius = 10
        self.pop.frame = CGRect(x: 10, y:self.view.frame.size.height/2 , width: self.pop.frame.size.width , height: self.view.frame.size.height/2 + 30)
        self.pop.isHidden = false
        NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
      },completion: { _ in
      })
    }
  }
}
//============================================================================
//MARK: Deallocating the Values
//============================================================================

extension RealtimeCaptureController{
  func deallocSession() {
    session.stopRunning()
    stop()
    ApplePayController.destroy()
  }
}
extension RealtimeCaptureController{
  func requestData() {
    let model = Networking()
    model.getCountryFlags { (response, error) in
      if error != nil {
      } else if let response = response{
        let cName = UserDetails.haggleTargetCode
        if let CountryName = UserDetails.countryAndCodeAndIcon["code"] {
          let CountryIcon = UserDetails.countryAndCodeAndIcon["icon"]
          for i in 0..<(CountryName.count) {
            if cName == CountryName[i]{
              print(CountryIcon![i])
              UserDetails.scannedCurrency.scannedCurrencyFlag = CountryIcon![i]
              UserDetails.haggleHomeIcon = UserDetails.scannedCurrency.scannedCurrencyFlag
              StrongBoxController.sharedInstance.storeUserDefault(data: cName, storeType: "haggleTargetCode")
              //                            StrongBoxController.sharedInstance.storeUserDefaultDataTypes(data: cName, storeType: "haggleTargetCode")
              StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleHomeIcon, storeType: "haggleHomeIcon")
              StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.scannedCurrency.scannedCurrencyFlag, storeType: "scannedCurrency.scannedCurrencyFlag")
            }
          }
          
          if let countryName = UserDetails.haggleHomeFlagName as? String {
            let CountryFlagName = UserDetails.countryAndCodeAndIcon["country"]
            for i in 0..<(CountryFlagName!.count) where countryName == CountryFlagName![i]{
              let CountryIcon = UserDetails.countryAndCodeAndIcon["icon"]
              UserDetails.haggleTargetIcon = CountryIcon![i]
              
              StrongBoxController.sharedInstance.storeUserDefault(data: self.homeCurrencyCode, storeType: "haggleHomeCode")
              StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleTargetIcon, storeType: "haggleTargetIcon")
            }
          }else{
            
            for i in 0..<(CountryName.count) {
              if UserDetails.haggleHomeCode == CountryName[i]{
                print(CountryIcon![i])
                UserDetails.haggleTargetIcon = CountryIcon![i]
                StrongBoxController.sharedInstance.storeUserDefault(data: self.homeCurrencyCode, storeType: "haggleHomeCode")
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleTargetIcon, storeType: "haggleTargetIcon")
              }
            }
          }
        }
      }
    }
  }
}

extension RealtimeCaptureController: applePayDelegate {
  func paymentSuccess(paymentSuccess: PKPaymentAuthorizationStatus) {
    
  }
  
  @objc func applePayClicked(){
    let amount = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.PercentageCalculation.ConvertedAmount)
    let nsnumber =  decimal(with: amount.joined())
    
    if let nameArray = UserDetails.countryAndCodeAndIcon["country"]{
      let iconArray = UserDetails.countryAndCodeAndIcon["icon"]
      for i in 0..<(nameArray.count) where nameArray[i] == applePayCurrencyName{
        print(iconArray![i])
        ApplePayController.sharedInstance.paymentClicked(parent: self, countryCode:  iconArray![i].uppercased(), currencyCode: applePayCurrency, ProductName: "Currency", amount: nsnumber)
      }
    }
  }
  func decimal(with string: String) -> NSDecimalNumber {
    let formatter = NumberFormatter()
    formatter.generatesDecimalNumbers = true
    return formatter.number(from: string) as? NSDecimalNumber ?? 0
  }
}
