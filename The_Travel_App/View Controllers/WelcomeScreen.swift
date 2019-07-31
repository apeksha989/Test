//
//  WelcomeScreen.swift
//  Haggle
//
//  Created by Anil Kumar on 28/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import CoreLocation
import AVKit

class WelcomeScreen: UIViewController {
  
  lazy var dimView          =  UIView(frame: UIScreen.main.bounds)
  lazy var Indicator        =  UIActivityIndicatorView()
  
  private let welcomeLabel       = UILabelFactory(text: "Welcome Aboard!")
    .numberOf(lines: 0)
    .textAlignment(with: .left)
    .textColor(with:  UIColor.white)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 25.0)!)
    .registerSDK(Register: "Montserrat-SemiBold", type: "otf")
    .build()
  
  private let descriptionLabel       = UILabelFactory(text: "The Travel App helps organise your future trips & documents with useful tools to support you on your adventure!")
    .numberOf(lines: 0)
    .textAlignment(with: .left)
    .textColor(with:  UIColor.white)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 15.0)!)
    .registerSDK(Register: "Montserrat-Regular", type: "otf")
    .build()
  
  private let letsGoButton         = UIButtonFactory(title: "LETS GO", style: .normal)
    .backgroundColour(with: UIColor.clear)
    .cornerRadious(with: 20.0)
    .textAlignmentButton(with: NSTextAlignment.center)
    .setTitileColour(with: UIColor.white)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14.0)!)
    .registerSDK(Register: "Montserrat-Medium", type: "otf")
    .addTarget(self, action: #selector(letsGoButtonTapped), for: .touchUpInside)
    .build()
  
  var country = String()
  override public func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------WelcomeScreen------------>😀")
    self.navigationController?.isNavigationBarHidden = true
    let bun = Bundle(identifier: BudleIdentifire.Identifire)
    if let urlPath = bun?.path(forResource: "test", ofType: "mp4"){
      VideoBackground.shared.play(view: view, url: URL(fileURLWithPath: urlPath))
    }else{
      try? VideoBackground.shared.play(view: view, videoName: "test", videoType: "mp4")
    }
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    
    addSubViews()
    bringSubViews()
    setUpConstraintsForAttributes()
    
  }
  
  func bringSubViews(){
    bringSubView(label: welcomeLabel)
    bringSubView(label: descriptionLabel)
    bringSubView(button: letsGoButton)
  }
  func addSubViews(){
    view.addSubview(dimView)
    view.addSubview(welcomeLabel)
    view.addSubview(descriptionLabel)
    view.addSubview(letsGoButton)
  }
  // Do any additional setup after loading the view.
  @objc func letsGoButtonTapped(){
    if let string = UserDetails.locationProperties.shared.countryCode, !string.isEmpty {
    }else{
      letsGoButton.loadingIndicator(show: true)
      letsGoButton.setTitle("", for: .normal)
      getCurrenctLocationCode()
    }
  }
  
  deinit {
    print("☺️ Deinitialization WelcomeViewController --->",WelcomeScreen.self)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    gradiantViewButton(letsGoButton)
  }
  
  func setUpConstraintsForAttributes() {
    welcomeLabel.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: view.frame.size.height/5, paddingLeft: 40.0, paddingBottom: 0.0, paddingRight: 0.0, width: 270.0, height: 35.0, enableInsets: true)
    
    descriptionLabel.layoutAnchor(top: welcomeLabel.bottomAnchor, left: welcomeLabel.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 10.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: view.frame.size.width/2+view.frame.size.width/4, height: 80, enableInsets: true)
    
    if #available(iOS 11.0, *) {
      letsGoButton.layoutAnchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY : nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 27, paddingRight: 0.0, width: view.frame.size.width - 87, height: 51, enableInsets: true)
    } else {
      letsGoButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY : nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 27, paddingRight: 0.0, width: view.frame.size.width - 87, height: 51, enableInsets: true)
    }
  }
  
  //============================================================================
  //MARK: Location Setup functions
  //============================================================================
  
  func getCurrenctLocationCode(){
    if Reachability.isConnectedToNetwork() {
      
      LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { [weak self] (location:CLLocation?, placemark:CLPlacemark?, error:NSError?) in
        if error != nil {
          self?.letsGoButton.loadingIndicator(show: false)
          self?.letsGoButton.setTitle("LETS GO", for: .normal)
          self?.showConfirmAlert(title: "", message: (error?.localizedDescription)!, buttonTitle: "Ok", buttonStyle: .default) { [weak self](action) in
            self?.navigationController?.popToRootViewController(animated: true)
          }
          return
        }
        guard let _ = location else {
          return
        }
        UserDetails.locationProperties.shared.countryName = placemark?.country
        self?.requestData()
        Networking.sharedInstance.requestForGetCountryCode(country: UserDetails.locationProperties.shared.countryName!) { [weak self] (success, result, error) in
          if success == true{
            UserDetails.locationProperties.shared.countryCode = result
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.locationProperties.shared.countryName!, storeType: "LocationName")
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.locationProperties.shared.countryCode!, storeType: "LocationCode")
            self?.letsGoButton.loadingIndicator(show: false)
            self?.letsGoButton.setTitle("LETS GO", for: .normal)
            self?.delay(0.4, closure: {
              self?.popOrPushToViewController("OnBoardingScreens")
            })
          }
        }
      }
    }else{
      showConfirmAlert(title: "", message: "Sorry, we can't connect right now. Please check your internet connection and try again.", buttonTitle: "Ok", buttonStyle: .default) { [weak self] (action) in
        self?.navigationController?.popToRootViewController(animated: true)
      }
    }
  }
}

extension WelcomeScreen{
  func requestData() {
    let model = Networking()
    model.getCountryFlags { (response, error) in
      if error != nil {
      } else if let response = response{
        self.setDataWithResponse(response: response as [DataModelItem])
      }
    }
  }
  func setDataWithResponse(response:[DataModelItem]){
    
    var nameArr : [String] = []
    var codeArr : [String] = []
    var iconArr : [String] = []
    
    for res in response{
      nameArr.append(res.name!)
      codeArr.append(res.currencyCode!)
      iconArr.append(res.alpha2!)
      
      UserDetails.countryAndCodeAndIcon.updateValue(nameArr, forKey: "country")
      UserDetails.countryAndCodeAndIcon.updateValue(codeArr, forKey: "code")
      UserDetails.countryAndCodeAndIcon.updateValue(iconArr, forKey: "icon")
    }
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.countryAndCodeAndIcon, storeType: "countryAndCodeAndIcon")
    let cName = UserDetails.locationProperties.shared.countryName
    if let CountryNames = UserDetails.countryAndCodeAndIcon["country"] {
      let CountryIcons = UserDetails.countryAndCodeAndIcon["icon"]
      for i in 0..<(CountryNames.count) {
        if cName == CountryNames[i]{
          StrongBoxController.sharedInstance.storeUserDefault(data: CountryIcons![i], storeType: "geticon")
          UserDetails.geticon.icon = CountryIcons![i]
        }
      }
    }
  }
}
