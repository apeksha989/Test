
//
//  ManualInputController.swift
//  Haggle
//
//  Created by Anil Kumar on 15/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import PassKit
import Stripe

class ManualInputController: UIViewController {
  
  var tempCurr =              String()
  var tempCurr1 =             String()
  var setIdentifire =         Int()
  var dotLocation =           Int()
  var getIntValue =           Int()
  var deviceModel =           UIDevice().type
  var scanCode                  = String()
  var convertCode               = String()
  var cName                     = String()
  var scanIcon                  = String()
  var convertIcon               = String()
  var countryCode               = String()
  var ApplePayCurrencyCode = String()
  var ApplePayCountryName = String()
  var ApplePayAmount = String()

  private let navigationBarView    = UIViewFactory().build()
  
  private let backButton           = UIButtonFactory(title: "")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    .build()
  
  private let titleLabel           = UILabelFactory(text: "")
    .textAlignment(with: .center)
    .build()
  
  private var homeCurrencyFlag     =  UIImageFactory()
    .setImage(imageString: "ad")
  .build()
  private var tripCurrencyFlag     =  UIImageFactory()
  .build()
  
  private var enterAmountLabel     =  UILabelFactory(text: "ENTER AMOUNT".uppercased())
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 10.13)!)
    .textColor(with: UIColor(red: 0.29, green: 0.565, blue: 0.886, alpha: 1))
    .setAlpha(value: 1.0)
  .build()

  private var inputAmountView      =  UIViewFactory()
    .clipToBounds(Bool: true)
    .masksToBounds(Bool: false)
    .shadowColor(color: UIColor(red: 0.85, green: 0.89, blue: 0.91, alpha: 0.50))
    .shadowOpacity(opaCity: 0.7)
    .shadowOffset(offSetWith: 0, offSetHeignt: 6)
    .cornerRadious(value: 5)
    .borderColor(color: UIColor(red: 0.86, green: 0.87, blue: 0.89, alpha: 0.30))
    .borderWith(value: 1)
    .backgroundColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .setAlpha(alpha: 1)
  .build()
  
  private var homeCurrencyDropDown =  UIButtonFactory(title: "")
    .setBackgroundImage(image: "ExpandMore")
    .setTintColor(color: UIColor(red: 0.173, green: 0.51, blue: 0.745, alpha: 1.0))
    .addTarget(self, action: #selector(homeCurrencyDropDownTapped), for: .touchUpInside)
  .build()

  private var myTripCurrencyLabel  =  UILabelFactory(text: "HOME CURRENCY".uppercased())
    .setAlpha(value: 1.0)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 10.13)!)
    .textColor(with: UIColor(red: 0.29, green: 0.565, blue: 0.886, alpha: 1))
  .build()
  
  private var tripCurrencyView     =  UIViewFactory()
    .clipToBounds(Bool: true)
    .masksToBounds(Bool: false)
    .shadowColor(color: UIColor(red: 0.85, green: 0.89, blue: 0.91, alpha: 0.50))
    .shadowOpacity(opaCity: 0.7)
    .shadowOffset(offSetWith: 0, offSetHeignt: 6)
    .cornerRadious(value: 5)
    .borderColor(color: UIColor(red: 0.86, green: 0.87, blue: 0.89, alpha: 0.30))
    .borderWith(value: 1)
    .backgroundColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .setAlpha(alpha: 1)
  .build()
  
  private var tripCurrencyDropDown =   UIButtonFactory(title: "")
      .setBackgroundImage(image: "ExpandMore")
      .setTintColor(color: UIColor(red: 0.173, green: 0.51, blue: 0.745, alpha: 1.0))
      .addTarget(self, action: #selector(tripCurrencyDropDownTapped), for: .touchUpInside)
  .build()
  
  private var tripCurrencyTextBox  =  UITextFieldFactory()
    .setBorderStyle(with: .none)
    .setKeyboardType(type: .decimalPad)
    .textAlignment(with: .right)
    .setFont(font: UIFont(name: "OpenSans-Regular", size: 27.72)!)
    .textColor(color: UIColor(red: 1.00, green: 0.42, blue: 0.18, alpha: 1))
  .build()

  private var ratesLabel           =  UILabelFactory(text: "")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "OpenSans-Regular", size: 9)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  private var applePay             =  UIButtonFactory(title: "")
    .setBackgroundImage(image: "Apple_pay")
  .build()
  
  private var clear                =  UIButtonFactory(title: "CLEAR")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .setTitileColour(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
    .textAlignmentButton(with: .center)
    .addTarget(self, action: #selector(clearButtonClicked), for: .touchUpInside)
  .build()
  
  private var Haggle               =  UIButtonFactory(title: "HAGGLE")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .setTitileColour(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
    .textAlignmentButton(with: .center)
  .build()
  
  private var homeCurrencyTextBox  =  UITextFieldFactory()
    .setBorderStyle(with: .none)
    .setKeyboardType(type: .decimalPad)
    .textAlignment(with: .right)
    .setFont(font: UIFont(name: "OpenSans-Regular", size: 27.72)!)
    .textColor(color: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  
  override func viewDidLayoutSubviews() {
    gradiantView(navigationBarView, self)
    backButton.setImage(UIImage(named: "BackBtn"), for: .normal)
    backButton.tintColor = UIColor.white
    titleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 19.0)
    titleLabel.textColor = UIColor.white
    titleLabel.text = "Manual Input"
    homeCurrencyFlag.layer.masksToBounds = true
    homeCurrencyFlag.layer.cornerRadius = homeCurrencyFlag.frame.size.height / 2
    tripCurrencyFlag.layer.masksToBounds = true
    tripCurrencyFlag.layer.cornerRadius = tripCurrencyFlag.frame.size.height / 2
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------ManualInputController------------>😀")
    ApplePayController.sharedInstance.delegate = self
    addSubviews()
    bringSubViews()
    applePay.addTarget(self, action: #selector(applePayClicked), for: .touchUpInside)
    setUpConstraintsToAttributes()
    
    homeCurrencyTextBox.delegate = self
    tripCurrencyTextBox.delegate = self
    
    let data = dataValue()
    ratesLabel.text = data
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tapGesture)
    
    let imageTapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.showCoutryPickerFirst(_:)))
    homeCurrencyFlag.addGestureRecognizer(imageTapGuesture)
    homeCurrencyFlag.isUserInteractionEnabled = true
    
    let imageTapGuesture1 = UITapGestureRecognizer(target: self, action: #selector(self.showCoutryPickerSecond(_:)))
    tripCurrencyFlag.addGestureRecognizer(imageTapGuesture1)
    tripCurrencyFlag.isUserInteractionEnabled = true
    
    Haggle.addTarget(self, action: #selector(ManualInputController.haggleClicked), for: .touchUpInside)
    homeCurrencyTextBox.addTarget(self, action: #selector(homeCurrencyTextBoxTapped), for: .touchDown)
    tripCurrencyTextBox.addTarget(self, action: #selector(tripCurrencyTextBoxTapped), for: .touchDown)
    
    if scanFlag {
        let scannedAmount   = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.PercentageCalculation.scannedAmount)
        let convertedAmount = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.PercentageCalculation.ConvertedAmount)
        
        if UserDetails.haggleTargetIcon == "" {
            tripCurrencyFlag.image   = UIImage(named: (StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "geticon") as! String))
        }else {
            tripCurrencyFlag.image   = UIImage(named: UserDetails.haggleTargetIcon)
        }
        homeCurrencyTextBox.text = scannedAmount.joined()
        tripCurrencyTextBox.text = convertedAmount.joined()
        homeCurrencyFlag.image   = UIImage(named: UserDetails.haggleHomeIcon)
    }else {
        requestData()
    }
    let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    numberToolbar.barStyle = .default
    numberToolbar.items = [
      UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ManualInputController.cancelButton_Clicked)),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ManualInputController.convertButton_Clicked))]
    numberToolbar.sizeToFit()
    homeCurrencyTextBox.inputAccessoryView = numberToolbar
    tripCurrencyTextBox.inputAccessoryView = numberToolbar
    tripCurrencyTextBox.adjustsFontSizeToFitWidth = true
    homeCurrencyTextBox.adjustsFontSizeToFitWidth = true
    placeHolder()
  }
  @objc func homeCurrencyTextBoxTapped(){
    tripCurrencyView.layer.borderWidth = 0
    tripCurrencyView.layer.borderColor = UIColor.clear.cgColor
    
    UIView.animate(withDuration: 0.2) {
      self.inputAmountView.layer.borderWidth = 1
      self.inputAmountView.layer.borderColor = UIColor(red: 160/255.0, green: 190/255.0, blue: 217/255.0, alpha: 1.0).cgColor
    }
  }
  
  @objc func tripCurrencyTextBoxTapped(){
    inputAmountView.layer.borderWidth = 0
    inputAmountView.layer.borderColor = UIColor.clear.cgColor
    UIView.animate(withDuration: 0.2) {
      self.tripCurrencyView.layer.borderWidth = 1
      self.tripCurrencyView.layer.borderColor = UIColor(red: 160/255.0, green: 190/255.0, blue: 217/255.0, alpha: 1.0).cgColor
    }
  }
  @objc func haggleClicked(){
    if (!(homeCurrencyTextBox.text?.isEmpty)!) && (!(tripCurrencyTextBox.text?.isEmpty)!){
      UserDetails.changedManualCurrency.changedManualCurrencyBool = true
      print(scanCode)
      print(convertCode)
      let scanSymbol  = getSymbolForCurrencyCode(code: scanCode)
      let convertSymbol = getSymbolForCurrencyCode(code: convertCode)
      UserDetails.PercentageCalculation.scannedAmount = convertSymbol + homeCurrencyTextBox.text!
      UserDetails.PercentageCalculation.ConvertedAmount = scanSymbol + tripCurrencyTextBox.text!
      popOrPushToViewController("HaggleMainScreen")
    }else{
      showConfirmAlert(title: "Warning", message: "No Inputs Given", buttonTitle: "OK", buttonStyle: .default, confirmAction: nil)
    }
  }
  func bringSubViews(){
    bringSubView(button: backButton)
    bringSubView(label: titleLabel)
    bringSubView(label: enterAmountLabel)
    bringSubView(label: myTripCurrencyLabel)
    bringSubView(label: ratesLabel)
    bringSubView(button: applePay)
    bringSubView(button: clear)
    bringSubView(button: Haggle)
  }
  func addSubviews(){
    view.addSubview(navigationBarView)
    view.addSubview(backButton)
    view.addSubview(titleLabel)
    view.addSubview(enterAmountLabel)
    view.addSubview(inputAmountView)
    view.addSubview(ratesLabel)
    view.addSubview(applePay)
    view.addSubview(clear)
    view.addSubview(Haggle)
    view.addSubview(myTripCurrencyLabel)
    view.addSubview(tripCurrencyView)
    
    inputAmountView.addSubview(homeCurrencyFlag)
    inputAmountView.addSubview(homeCurrencyDropDown)
    inputAmountView.addSubview(homeCurrencyTextBox)
    tripCurrencyView.addSubview(tripCurrencyFlag)
    tripCurrencyView.addSubview(tripCurrencyDropDown)
    tripCurrencyView.addSubview(tripCurrencyTextBox)
    
    view.bringSubviewToFront(inputAmountView)
    inputAmountView.bringSubviewToFront(homeCurrencyFlag)
    inputAmountView.bringSubviewToFront(homeCurrencyDropDown)
    inputAmountView.bringSubviewToFront(homeCurrencyTextBox)
    
    view.bringSubviewToFront(tripCurrencyView)
    tripCurrencyView.bringSubviewToFront(tripCurrencyFlag)
    tripCurrencyView.bringSubviewToFront(tripCurrencyDropDown)
    tripCurrencyView.bringSubviewToFront(tripCurrencyTextBox)
  }
  
  func placeHolder(){
    homeCurrencyTextBox.attributedPlaceholder = NSAttributedString(string: "0.00",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)])
    tripCurrencyTextBox.attributedPlaceholder = NSAttributedString(string: "0.00",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 0.42, blue: 0.18, alpha: 1)])
  }
  
  @objc func homeCurrencyDropDownTapped() {
    showCoutryPicker(tagValue: 0)
  }
  
  @objc func tripCurrencyDropDownTapped() {
    showCoutryPicker(tagValue: 1)
  }
  
  @objc func convertButton_Clicked(_ sender:Any){
    homeCurrencyTextBox.resignFirstResponder()
    tripCurrencyTextBox.resignFirstResponder()
    if  getIntValue == 1 {
      if let textValue = homeCurrencyTextBox.text {
        getValue(homeCurrencyTextBox, value: textValue)
      }
    }else if getIntValue == 2 {
      if let textValue = tripCurrencyTextBox.text {
        getValue(tripCurrencyTextBox, value: textValue)
      }
    }
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == homeCurrencyTextBox{
      getIntValue = 1
    }else{
      getIntValue = 2
    }
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == homeCurrencyTextBox{
      if (textField.text!.count < 0){
        textField.attributedPlaceholder = NSAttributedString(string: "0.00",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)])
      }
    }else{
      if (textField.text!.count < 0){
        textField.attributedPlaceholder = NSAttributedString(string: "0.00",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)])
      }
    }
  }
  
  @objc func cancelButton_Clicked(_ sender:Any){
    homeCurrencyTextBox.resignFirstResponder()
    tripCurrencyTextBox.resignFirstResponder()
  }
  
  
  deinit {
    print("Memery Leak ManualInputController")
  }
  
  @objc func clearButtonClicked() {
    homeCurrencyTextBox.text = ""
    tripCurrencyTextBox.text = ""
    placeHolder()
  }
  @objc func backButtonTapped(){
    NotificationCenter.default.post(name: .BackButtonTapped, object: nil)
    popOrPushToViewController("RealtimeCaptureController")
  }
  
  @objc func showCoutryPickerFirst(_ sender: UITapGestureRecognizer) {
    showCoutryPicker(tagValue: (sender.view?.tag)!)
  }
  
  @objc func showCoutryPickerSecond(_ sender: UITapGestureRecognizer) {
    sender.view?.tag = 1
    showCoutryPicker(tagValue: (sender.view?.tag)!)
  }
  
  func showCoutryPicker(tagValue:Int){
    setIdentifire = tagValue
    UserDetails.ClickBool.ManualClicked = false
    presentDissmiss(controller: "CountryViewController")
    UserDetails.Identifires.shared.getSetIdentifire = setIdentifire
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
    
    countryCode = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationCode") as! String
    countryCode(code: UserDetails.CountryDelegateModel.code, icon: UserDetails.CountryDelegateModel.icon, identifire: UserDetails.CountryDelegateModel.identifire)
  }
  override func viewWillDisappear(_ animated: Bool) {
    UserDetails.CountryDelegateModel.code = ""
    UserDetails.CountryDelegateModel.icon = ""
    UserDetails.CountryDelegateModel.identifire = 3
    ApplePayController.destroy()
    Networking.destroy()
  }
}
extension ManualInputController{
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    switch string {
    case "0","1","2","3","4","5","6","7","8","9":
      return true
    case ".":
      let array = Array(textField.text!)
      var decimalCount = 0
      for character in array {
        if character == "." {
          decimalCount = decimalCount + 1
        }
      }
      
      if decimalCount >= 1 {
        return false
      } else {
        return true
      }
    default:
      let array = Array(string)
      if array.count == 0 {
        return true
      }
      return false
    }
  }
  
  func getValue( _ textField: UITextField,  value: String){
    if !UserDetails.haggleHomeCode.isEmpty && !UserDetails.haggleTargetCode.isEmpty{
      
      print("HomeCode---->", UserDetails.haggleHomeCode)
      print("TargetCode---->", UserDetails.haggleTargetCode)
      
      convertion(textField: textField, base: UserDetails.haggleTargetCode, target: UserDetails.haggleHomeCode, value: value)
    }
  }
  
  @objc func hideKeyboard() {
    view.endEditing(true)
    if  getIntValue == 1 {
      if let textValue = homeCurrencyTextBox.text {
        homeCurrencyTextBox.layer.borderWidth = 0
        homeCurrencyTextBox.layer.borderColor = UIColor.clear.cgColor
        getValue(homeCurrencyTextBox, value: textValue)
      }
    }else if getIntValue == 2 {
      if let textValue = tripCurrencyTextBox.text {
        tripCurrencyTextBox.layer.borderWidth = 0
        tripCurrencyTextBox.layer.borderColor = UIColor.clear.cgColor
        getValue(tripCurrencyTextBox, value: textValue)
      }
    }
  }
}

extension ManualInputController{
  func countryCode(code: String, icon: String, identifire: Int) {
    if !code.isEmpty,!icon.isEmpty{
      if identifire == 0{
        UserDetails.haggleHomeIcon = icon
        UserDetails.haggleTargetCode = code
        
        print("HomeCode---->", UserDetails.haggleHomeCode)
        print("TargetCode---->", UserDetails.haggleTargetCode)
        tempCurr = code
        convertCode = code
        UserDetails.changedManualCurrency.manualConvertImage = icon
        StrongBoxController.sharedInstance.storeUserDefault(data: code, storeType: "haggleTargetCode")
        StrongBoxController.sharedInstance.storeUserDefault(data: icon, storeType: "haggleHomeIcon")
        self.homeCurrencyFlag.image = UIImage(named: icon)
        //        if !tempCurr1.isEmpty{
        convertion1(base: UserDetails.haggleTargetCode, target: UserDetails.haggleHomeCode, value: homeCurrencyTextBox)
        //        }else{
        //          convertion1(base: haggleHomeCode, target: haggleTargetCode, value: homeCurrencyTextBox)
        //        }
      }
      if identifire == 1{
        UserDetails.haggleTargetIcon = icon
        UserDetails.haggleHomeCode = code
        print("HomeCode---->", UserDetails.haggleHomeCode)
        print("TargetCode---->", UserDetails.haggleTargetCode)
        tempCurr1 = code
        scanCode = code
        UserDetails.changedManualCurrency.manualScanImage = icon
        self.tripCurrencyFlag.image = UIImage(named: icon)
        StrongBoxController.sharedInstance.storeUserDefault(data: code, storeType: "haggleHomeCode")
        StrongBoxController.sharedInstance.storeUserDefault(data: icon, storeType: "haggleTargetIcon")
        convertion1(base: UserDetails.haggleTargetCode, target: UserDetails.haggleHomeCode, value: tripCurrencyTextBox)
      }
    }
  }
  
  func convertion1(base: String,target:String,value:UITextField){
    if value == homeCurrencyTextBox {
      ApplePayAmount = value.text!
      Networking.sharedInstance.convertion(baseCurrency: base, targetCurrency: target, Value: homeCurrencyTextBox.text!) { (success, error, result) in
        if success == true{
          self.tripCurrencyTextBox.text = result
        }
      }
    }else if value == tripCurrencyTextBox{
      ApplePayAmount = value.text!
      Networking.sharedInstance.convertion(baseCurrency: target, targetCurrency: base, Value: tripCurrencyTextBox.text!) { (success, error, result) in
        if success == true{
          self.homeCurrencyTextBox.text = result
        }
      }
    }
  }
}


extension ManualInputController{
  func requestData() {
    if UserDetails.ChangeHomeCurrency.homeCurrencyName.isEmpty{
    cName = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationName") as! String
    }else {
      cName = UserDetails.ChangeHomeCurrency.homeCurrencyName
    }
    
    if let CountryNames = UserDetails.countryAndCodeAndIcon["country"] {
      let CountryCodes = UserDetails.countryAndCodeAndIcon["code"]
      let CountryIcon = UserDetails.countryAndCodeAndIcon["icon"]
      if UserDetails.searchCountryFlag{
        if UserDetails.ChangeHomeCurrency.homeCurrencyName.isEmpty{
          for i in 0..<(CountryNames.count) {
            if cName == CountryNames[i] {
              self.tripCurrencyFlag.image = UIImage(named: CountryIcon![i])
              UserDetails.changedManualCurrency.manualScanImage = CountryIcon![i]
              scanCode         = CountryCodes![i]
              UserDetails.haggleTargetIcon = CountryIcon![i]
              UserDetails.haggleHomeCode   = CountryCodes![i]
            }
          }
        }else {
          for i in 0..<(UserDetails.recentCountry.count) {
            if cName == UserDetails.recentCountryName[i]{
              self.tripCurrencyFlag.image = UIImage(named: UserDetails.recentCountryFlag[i])
              UserDetails.changedManualCurrency.manualScanImage = UserDetails.recentCountryFlag[i]
              scanCode         = UserDetails.recentCountryCode[i]
              UserDetails.haggleTargetIcon = UserDetails.recentCountryFlag[i]
              UserDetails.haggleHomeCode   = UserDetails.recentCountryCode[i]
            }
          }
        }
        for i in 0..<(UserDetails.recentCountry.count) {
          if "AUD" == UserDetails.recentCountryCode[i] {
            UserDetails.haggleHomeIcon   = "au"
            UserDetails.haggleTargetCode = "AUD"
            self.homeCurrencyFlag.image = UIImage(named: "au")
            UserDetails.changedManualCurrency.manualConvertImage = "au"
            convertCode = CountryCodes![i]
          }
        }
      }else{
        for i in 0..<(CountryNames.count) {
          if cName == CountryNames[i] {
            self.tripCurrencyFlag.image = UIImage(named: CountryIcon![i])
            UserDetails.changedManualCurrency.manualScanImage = CountryIcon![i]
            scanCode         = CountryCodes![i]
            UserDetails.haggleTargetIcon = CountryIcon![i]
            UserDetails.haggleHomeCode   = CountryCodes![i]
          }
          if "AUD" == CountryCodes![i] {
            UserDetails.haggleHomeIcon   = "au"
            UserDetails.haggleTargetCode = "AUD"
            self.homeCurrencyFlag.image = UIImage(named: "au")
            UserDetails.changedManualCurrency.manualConvertImage = "au"
            convertCode = CountryCodes![i]
          }
        }
      }
    }
  }
}

extension ManualInputController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == homeCurrencyTextBox{
      inputAmountView.layer.borderWidth = 0
      inputAmountView.layer.borderColor = UIColor.clear.cgColor
      
    }else if textField == tripCurrencyTextBox{
      tripCurrencyView.layer.borderWidth = 0
      tripCurrencyView.layer.borderColor = UIColor.clear.cgColor
    }
    return true
  }
  
  func convertion(textField : UITextField,base: String,target:String,value:String){
    if textField == homeCurrencyTextBox {
      ApplePayAmount = value
      Networking.sharedInstance.convertion(baseCurrency: base, targetCurrency: target, Value: value) { (success, error, result) in
        if success == true{
          self.tripCurrencyTextBox.text = result
          self.inputAmountView.layer.borderWidth = 0
          self.inputAmountView.layer.borderColor = UIColor.clear.cgColor
          self.tripCurrencyView.layer.borderWidth = 0
          self.tripCurrencyView.layer.borderColor = UIColor.clear.cgColor
        }else{
          self.showConfirmAlert(title: "", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }
      }
    }else if textField == tripCurrencyTextBox{
      ApplePayAmount = value
      Networking.sharedInstance.convertion(baseCurrency: target, targetCurrency: base, Value: value) { (success, error, result) in
        if success == true{
          self.homeCurrencyTextBox.text = result
          self.inputAmountView.layer.borderWidth = 0
          self.inputAmountView.layer.borderColor = UIColor.clear.cgColor
          self.tripCurrencyView.layer.borderWidth = 0
          self.tripCurrencyView.layer.borderColor = UIColor.clear.cgColor
        }else{
          self.showConfirmAlert(title: "", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }
      }
    }
  }
  
  func dataValue()-> String{
    let currentDate = Date()
    var dateString : String?
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "MMM"
    let firstPartStringDate = dateFormatter.string(from: currentDate)
    
    dateFormatter.dateFormat = "yyyy"
    let lastPartStringDate = dateFormatter.string(from: currentDate)
    
    let day = Calendar.current.component(.day, from: currentDate)
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    if let ordinalDay = formatter.string(for: day){
      dateFormatter.dateFormat = "HH:mm"
      let timeHHMM = dateFormatter.string(from: currentDate)
      dateString = "These rates are correct as of, \(firstPartStringDate) \(ordinalDay), \(lastPartStringDate) at \(timeHHMM)"
    }
    return (dateString ?? "")
  }
}

extension ManualInputController: applePayDelegate {
  func paymentSuccess(paymentSuccess: PKPaymentAuthorizationStatus) {
    
  }
  
  @objc func applePayClicked(){
    if !tripCurrencyTextBox.text!.isEmpty {
      let nsnumber =  decimal(with: tripCurrencyTextBox.text ?? "0.0")
      
      let amount1 = matches(for: RegExpression.shared.NumberRegex, in: ApplePayAmount)
      _ =  decimal(with: amount1.joined())
      let countryName: String?
      if UserDetails.CountryDelegateModel.flagName.isEmpty{
        countryName = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationName") as? String
      }else{
        countryName = UserDetails.CountryDelegateModel.flagName
      }
      
      if let nameArray = UserDetails.countryAndCodeAndIcon["country"]{
        let iconArray = UserDetails.countryAndCodeAndIcon["icon"]
        for i in 0..<(nameArray.count) where nameArray[i] == countryName{
          print(iconArray![i])
          ApplePayController.sharedInstance.paymentClicked(parent: self, countryCode: iconArray![i], currencyCode: UserDetails.haggleHomeCode, ProductName: "Currency", amount: nsnumber)
        }
      }
    }
  }
  func decimal(with string: String) -> NSDecimalNumber {
    let formatter = NumberFormatter()
    formatter.generatesDecimalNumbers = true
    return formatter.number(from: string) as? NSDecimalNumber ?? 0
  }
}
extension ManualInputController{
  
  func setUpConstraintsToAttributes() {
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      
      navigationBarView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 100, enableInsets: true)
      
      backButton.layoutAnchor(top: nil, left: navigationBarView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: titleLabel.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
      
      titleLabel.layoutAnchor(top: nil, left: nil, bottom: navigationBarView.bottomAnchor, right: nil, centerX: navigationBarView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 30.0, paddingRight: 0.0, width: 200.0, height: 21.0, enableInsets: true)
    default:
      navigationBarView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 85, enableInsets: true)
      
      backButton.layoutAnchor(top: nil, left: navigationBarView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: navigationBarView.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
      
      titleLabel.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: navigationBarView.centerXAnchor, centerY: navigationBarView.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 200.0, height: 21.0, enableInsets: true)
    }
    
    enterAmountLabel.layoutAnchor(top: navigationBarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 35.0, paddingLeft: 30.0, paddingBottom: 0.0, paddingRight: 0.0, width: 93.0, height: 15.0, enableInsets: true)
    
    inputAmountView.layoutAnchor(top: enterAmountLabel.bottomAnchor, left: enterAmountLabel.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 15.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 30.0, width: 0.0, height: 70.0, enableInsets: true)
    
    homeCurrencyFlag.layoutAnchor(top: nil, left: inputAmountView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: inputAmountView.centerYAnchor, paddingTop: 0.0, paddingLeft: 17.0, paddingBottom: 0.0, paddingRight: 0.0, width: 46.0, height: 46.0, enableInsets: true)
    
    homeCurrencyDropDown.layoutAnchor(top: nil, left: homeCurrencyFlag.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: homeCurrencyFlag.centerYAnchor, paddingTop: 0.0, paddingLeft: 10.0, paddingBottom: 0.0, paddingRight: 0.0, width: 25.0, height: 22.0, enableInsets: true)
    
    homeCurrencyTextBox.layoutAnchor(top: inputAmountView.topAnchor, left: homeCurrencyDropDown.rightAnchor, bottom: inputAmountView.bottomAnchor, right: inputAmountView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 10.0, paddingBottom: 0.0, paddingRight: 10.0, width: 0.0, height: 0.0, enableInsets: true)
    
    myTripCurrencyLabel.layoutAnchor(top: inputAmountView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 20.0, paddingLeft: 30.0, paddingBottom: 0.0, paddingRight: 0.0, width: 115.0, height: 15.0, enableInsets: true)
    
    tripCurrencyView.layoutAnchor(top: myTripCurrencyLabel.bottomAnchor, left: myTripCurrencyLabel.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 15.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 30.0, width: 0.0, height: 70.0, enableInsets: true)
    
    tripCurrencyFlag.layoutAnchor(top: nil, left: tripCurrencyView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: tripCurrencyView.centerYAnchor, paddingTop: 0.0, paddingLeft: 17.0, paddingBottom: 0.0, paddingRight: 0.0, width: 46.0, height: 46.0, enableInsets: true)
    
    tripCurrencyDropDown.layoutAnchor(top: nil, left: tripCurrencyFlag.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: tripCurrencyFlag.centerYAnchor, paddingTop: 0.0, paddingLeft: 10.0, paddingBottom: 0.0, paddingRight: 0.0, width: 25.0, height: 22.0, enableInsets: true)
    
    tripCurrencyTextBox.layoutAnchor(top: tripCurrencyView.topAnchor, left: tripCurrencyDropDown.rightAnchor, bottom: tripCurrencyView.bottomAnchor, right: tripCurrencyView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 10.0, paddingBottom: 0.0, paddingRight: 10.0, width: 0.0, height: 0.0, enableInsets: true)
    
    ratesLabel.layoutAnchor(top: tripCurrencyFlag.bottomAnchor, left: tripCurrencyView.leftAnchor, bottom: nil, right: tripCurrencyView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 20.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 15.0, enableInsets: true)
    
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      applePay.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 36, paddingRight: 0.0, width: 66.0, height: 42.0, enableInsets: true)
    default:
      applePay.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 16, paddingRight: 0.0, width: 66.0, height: 42.0, enableInsets: true)
    }
    
    clear.layoutAnchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: applePay.centerYAnchor, paddingTop: 0.0, paddingLeft: 38, paddingBottom: 0.0, paddingRight: 0.0, width: 50, height: 20, enableInsets: true)
    
    Haggle.layoutAnchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: applePay.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 38.0, width: 62.0, height: 20.0, enableInsets: true)
  }
  
}




