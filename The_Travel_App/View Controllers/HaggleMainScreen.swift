  
  import UIKit
  
  class HaggleMainScreen: UIViewController {
    
    private let titleLabel            = UILabelFactory(text: "Haggle")
      .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
      .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
      .textAlignment(with: .center)
      .build()
    
    private let backButton            = UIButtonFactory(title: "")
      .setBackgroundImage(image: "BackBtn")
      .setTintColor(color: .white)
      .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
      .build()
    
    private let amountLabel           = UILabelFactory(text: "Starting Amount")
      .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
      .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
      .build()
    
    private let homeCurrencyFlag      =  UIImageFactory()
      .setImage(imageString: "ad")
      .build()
    
    private let homeCurrencyFeild     = UITextFieldFactory()
      .setKeyboardType(type: .decimalPad)
      .setFont(font: UIFont(name: "Montserrat-Medium", size: 36)!)
      .textColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
      .setKeyboardReturnType(type: .done)
      .build()
    
    private let targetcurrencyFlag    =  UIImageFactory()
      .build()
    
    private let targetCurrencyFeild   = UITextFieldFactory()
      .setKeyboardType(type: .decimalPad)
      .setFont(font: UIFont(name: "Montserrat-Medium", size: 36)!)
      .textColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
      .setKeyboardReturnType(type: .done)
      .build()
    
    private let ratesStaus            = UILabelFactory(text: "")
      .numberOf(lines: 0)
      .textAlignment(with: .left)
      .textFonts(with: UIFont(name: "OpenSans-Regular", size: 8)!)
      .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
      .build()
    
    lazy var haggleTable           =   UITableView()
    
    private let sellerButton          = UIButtonFactory(title: "")
      .addTarget(self, action: #selector(sellerViewTapped), for: .touchUpInside)
      .build()
    
    let barView = UIViewFactory()
      .build()
    
    var getIntValue =           Int()
    var setIdentifire =         Int()
    var cName                    = String()
    var percentageScannedAmount : [String] = []
    var percentageConvertedAmount : [String] = []
    var scanValue             = String()
    var convertValue = String()
    var hagglePercentage         = ["-5%", "-10%", "-15%","-20%", "-25%"]
    
    var countryCode = String()
    
    let valueArray = RegExpression.shared.codeToSymbole.map {($0.value)}
    let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
      super.viewDidLoad()
      debugPrint("<---------HaggleMainScreen------------>😀")
      countryCode = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationCode") as! String
      if !UserDetails.shared.tripArray.isEmpty{
        UserDetails.newTripCreated.tripCreatedBool = false
      }
      
      if UserDetails.PercentageCalculation.ConvertedAmount.isEmpty ,UserDetails.PercentageCalculation.scannedAmount.isEmpty{
        sellerButton.isHidden = true
        requestData()
        UserDetails.PercentageCalculation.scannedAmount = ""
        UserDetails.PercentageCalculation.ConvertedAmount = ""
      }else{
        let symbol1 = self.matches(for: RegExpression.shared.symbolRegex, in: UserDetails.PercentageCalculation.scannedAmount)
        let symbol2 = self.matches(for: RegExpression.shared.symbolRegex, in: UserDetails.PercentageCalculation.ConvertedAmount)
        let v = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.PercentageCalculation.scannedAmount)
        let v2 = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.PercentageCalculation.ConvertedAmount)
        percentage(v.joined(), v2.joined(), symbol1.joined(), symbol2.joined(), UserDetails.PercentageCalculation.code)
        print(UserDetails.haggleHomeCode)
        print(UserDetails.haggleTargetCode)
        //            percentage(v.joined(), v2.joined(), "", "", PercentageCalculation.code)
        if (UserDetails.haggleTargetIcon == "") && (UserDetails.haggleHomeIcon == ""){
          requestData()
          homeCurrencyFeild.text      = UserDetails.PercentageCalculation.scannedAmount
          targetCurrencyFeild.text    = UserDetails.PercentageCalculation.ConvertedAmount
        }else if UserDetails.haggleHomeIcon == "" {
          homeCurrencyFlag.image      = UIImage(named: "au")
          targetcurrencyFlag.image    = UIImage(named: UserDetails.haggleTargetIcon)
          homeCurrencyFeild.text      = UserDetails.PercentageCalculation.scannedAmount
          targetCurrencyFeild.text    = UserDetails.PercentageCalculation.ConvertedAmount
        }else if UserDetails.haggleTargetIcon == "" {
          if !UserDetails.ChangeHomeCurrency.homeCurrencyIcon.isEmpty{
            homeCurrencyFlag.image      = UIImage(named: UserDetails.haggleHomeIcon)
            targetcurrencyFlag.image    = UIImage(named: UserDetails.ChangeHomeCurrency.homeCurrencyIcon)
            homeCurrencyFeild.text      = UserDetails.PercentageCalculation.scannedAmount
            targetCurrencyFeild.text    = UserDetails.PercentageCalculation.ConvertedAmount
          }else{
            homeCurrencyFlag.image      = UIImage(named: UserDetails.haggleHomeIcon)
            targetcurrencyFlag.image    = UIImage(named: (StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "geticon") as! String))
            homeCurrencyFeild.text      = UserDetails.PercentageCalculation.scannedAmount
            targetCurrencyFeild.text    = UserDetails.PercentageCalculation.ConvertedAmount
          }
        }else{
          homeCurrencyFlag.image      = UIImage(named: UserDetails.haggleHomeIcon)
          targetcurrencyFlag.image    = UIImage(named: UserDetails.haggleTargetIcon)
          homeCurrencyFeild.text      = UserDetails.PercentageCalculation.scannedAmount
          targetCurrencyFeild.text    = UserDetails.PercentageCalculation.ConvertedAmount
          print(UserDetails.haggleHomeCode)
          print(UserDetails.haggleTargetCode)
        }
      }
      setUpLayoutViews()
      let data = dataValue()
      ratesStaus.text = data
      
      haggleTable.register(HaggleTableCell.self, forCellReuseIdentifier: "HaggleTableCell")
      haggleTable.delegate = self
      haggleTable.dataSource = self
      haggleTable.tableFooterView = UIView()
      
      let tapGusture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
      barView.isUserInteractionEnabled = true
      barView.addGestureRecognizer(tapGusture)
      
      let imageTapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.showCoutryPickerFirst(_:)))
      homeCurrencyFlag.addGestureRecognizer(imageTapGuesture)
      homeCurrencyFlag.isUserInteractionEnabled = true
      
      let imageTapGuesture1 = UITapGestureRecognizer(target: self, action: #selector(self.showCoutryPickerSecond(_:)))
      targetcurrencyFlag.addGestureRecognizer(imageTapGuesture1)
      targetcurrencyFlag.isUserInteractionEnabled = true
      
      homeCurrencyFeild.delegate = self
      targetCurrencyFeild.delegate = self
      let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
      numberToolbar.barStyle = .default
      numberToolbar.items = [
        UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(HaggleMainScreen.cancelButton_Clicked)),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HaggleMainScreen.convertButton_Clicked))]
      numberToolbar.sizeToFit()
      homeCurrencyFeild.inputAccessoryView = numberToolbar
      targetCurrencyFeild.inputAccessoryView = numberToolbar
      targetCurrencyFeild.adjustsFontSizeToFitWidth = true
      homeCurrencyFeild.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
      homeCurrencyFeild.text = scanValue
      targetCurrencyFeild.text = convertValue
      
      let filter = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.PercentageCalculation.scannedAmount)
      getValue(homeCurrencyFeild, value: filter.joined())
      
      if !UserDetails.shared.tripArray.isEmpty{
        UserDetails.tripStartedFlag = true
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.tripStartedFlag, storeType: "tripStartedFlag")
      }
      if UserDetails.delegateFlag{
        countryCode(code: UserDetails.CountryDelegateModel.code, icon: UserDetails.CountryDelegateModel.icon, identifire: UserDetails.CountryDelegateModel.identifire)
      }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      UserDetails.CountryDelegateModel.identifire = 3
    }
    
    @objc func cancelButton_Clicked(_ sender:Any){
      homeCurrencyFeild.resignFirstResponder()
      targetCurrencyFeild.resignFirstResponder()
    }
    
    @objc func convertButton_Clicked(_ sender:Any){
      homeCurrencyFeild.resignFirstResponder()
      targetCurrencyFeild.resignFirstResponder()
      if  getIntValue == 1 {
        if let textValue = homeCurrencyFeild.text {
          let fillter = matches(for: RegExpression.shared.NumberRegex, in: textValue)
          getValue(homeCurrencyFeild, value: fillter.joined())
        }
      }else if getIntValue == 2 {
        if let textValue = targetCurrencyFeild.text {
          let fillter = matches(for: RegExpression.shared.NumberRegex, in: textValue)
          getValue(targetCurrencyFeild, value: fillter.joined())
        }
      }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      if textField == homeCurrencyFeild{
        getIntValue = 1
      }else{
        getIntValue = 2
      }
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
    
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      gradiantView(barView, self)
      
      homeCurrencyFlag.layer.masksToBounds = true
      homeCurrencyFlag.layer.cornerRadius = homeCurrencyFlag.frame.size.height/2
      
      targetcurrencyFlag.layer.masksToBounds = true
      targetcurrencyFlag.layer.cornerRadius = targetcurrencyFlag.frame.size.height/2
      
      gradiantViewButton(sellerButton)
      sellerButton.setTitle("ENTER SELLER VIEW", for: .normal)
      sellerButton.titleLabel?.textAlignment = NSTextAlignment.center
      sellerButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 14)
      sellerButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @objc func backButtonTapped() {
        haggleFlag = true
        homeCurrencyFlag.image  = nil
        targetcurrencyFlag.image = nil
        NotificationCenter.default.post(name: .BackButtonTapped, object: nil)
        NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
      print("Deinit in Haggle Main Screen")
    }
    
    func setUpLayoutViews(){
      view.addSubview(barView)
      barView.addSubview(titleLabel)
      barView.addSubview(backButton)
      barView.addSubview(amountLabel)
      barView.addSubview(homeCurrencyFlag)
      barView.addSubview(homeCurrencyFeild)
      barView.addSubview(targetcurrencyFlag)
      barView.addSubview(targetCurrencyFeild)
      barView.addSubview(ratesStaus)
      view.addSubview(haggleTable)
      view.addSubview(sellerButton)
      
      barView.bringSubviewToFront(titleLabel)
      barView.bringSubviewToFront(backButton)
      barView.bringSubviewToFront(amountLabel)
      barView.bringSubviewToFront(homeCurrencyFlag)
      barView.bringSubviewToFront(homeCurrencyFeild)
      barView.bringSubviewToFront(targetcurrencyFlag)
      barView.bringSubviewToFront(targetCurrencyFeild)
      barView.bringSubviewToFront(ratesStaus)
      view.bringSubviewToFront(haggleTable)
      view.bringSubviewToFront(sellerButton)
      
      setUpConstraintsToAttributes()
    }
    
    @objc func sellerViewTapped(){
      if let indexpath = haggleTable.indexPathForSelectedRow {
        haggleTable.deselectRow(at: indexpath, animated: true)
        delay(0.5) {
          print("qwew",UserDetails.PercentageCalculation.code)
          self.popOrPushToViewController("SellerViewScreen")
        }
      }else{
        print("qwe",UserDetails.PercentageCalculation.code)
        self.popOrPushToViewController("SellerViewScreen")
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
        dateString = "These rates are correct as of, \(firstPartStringDate) \(ordinalDay), \(lastPartStringDate) at \(timeHHMM) Rates displayed are indicative only and are subject to change."
      }
      return (dateString ?? "")
    }
  }
  
  extension HaggleMainScreen: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      UserDetails.AddToWalletScannedAmount = percentageScannedAmount[indexPath.row]
    }
  }
  
  extension HaggleMainScreen: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if percentageScannedAmount.count == 0  {
        if homeCurrencyFeild.text!.isEmpty{
          tableView.setEmptyMessage("No Data")
        }else{
          setLoadingScreen()
        }
        return 0
      }else{
        tableView.setEmptyMessage("")
        return hagglePercentage.count
      }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "HaggleTableCell", for: indexPath) as! HaggleTableCell
      cell.hagglePercentage.text = hagglePercentage[indexPath.row]
      cell.haggleAmount.text     = percentageScannedAmount[indexPath.row]
      cell.targetAmount.text     = percentageConvertedAmount[indexPath.row]
      return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      cell.alpha = 0
      UIView.animate(
        withDuration: 0.5,
        delay: 0.05 * Double(indexPath.row),
        animations: {
          cell.alpha = 1
      })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 61
    }
  }
  
  extension HaggleMainScreen{
    func requestData() {
      _ = RegExpression.shared.codeToSymbole.map {($0.value)}
      _ = RegExpression.shared.codeToSymbole.map {($0.key)}
      
      if !UserDetails.ChangeHomeCurrency.homeCurrencyName.isEmpty{
        cName = UserDetails.ChangeHomeCurrency.homeCurrencyName
      }else{
        cName = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationName") as! String
      }
      if let CountryNames = UserDetails.countryAndCodeAndIcon["country"] {
        let CountryCodes = UserDetails.countryAndCodeAndIcon["code"]
        let CountryIcon = UserDetails.countryAndCodeAndIcon["icon"]
        if UserDetails.searchCountryFlag{
          if UserDetails.ChangeHomeCurrency.homeCurrencyName.isEmpty{
            for i in 0..<(CountryNames.count) {
              if cName == CountryNames[i]{
                
                var CurrencySymbol = getSymbolForCurrencyCode(code:  CountryCodes![i])
                for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == CountryCodes![i]{
                  CurrencySymbol = valueArray[j]
                }
                targetCurrencyFeild.attributedPlaceholder = NSAttributedString(string: "\(CurrencySymbol)0.00",
                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)])
                UserDetails.haggleHomeCode = CountryCodes![i]
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleHomeCode, storeType: "haggleHomeCode")
                self.targetcurrencyFlag.image = UIImage(named: CountryIcon![i])
              }
            }
          }else{
            for i in 0..<(UserDetails.recentCountry.count) {
              if cName == UserDetails.recentCountryName[i]{
                var CurrencySymbol = getSymbolForCurrencyCode(code:  UserDetails.recentCountryCode[i])
                for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == UserDetails.recentCountryCode[i]{
                  CurrencySymbol = valueArray[j]
                }
                targetCurrencyFeild.attributedPlaceholder = NSAttributedString(string: "\(CurrencySymbol)0.00",
                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)])
                UserDetails.haggleHomeCode = UserDetails.recentCountryCode[i]
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleHomeCode, storeType: "haggleHomeCode")
                self.targetcurrencyFlag.image = UIImage(named: UserDetails.recentCountryFlag[i])
              }
            }
          }
          for i in 0..<(UserDetails.recentCountry.count) {
            if UserDetails.haggleHomeIcon.isEmpty{
              if UserDetails.TargetCurrency.targetCurrencyCode == UserDetails.recentCountryCode[i]{
                
                var CurrencySymbol = getSymbolForCurrencyCode(code: UserDetails.recentCountryCode[i])//UserDetails.recentCountryCode[i]
                for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == UserDetails.recentCountryCode[i]{
                  CurrencySymbol = valueArray[j]
                }
                homeCurrencyFeild.attributedPlaceholder = NSAttributedString(string: "\(CurrencySymbol)0.00",
                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)])
                UserDetails.haggleTargetCode = UserDetails.recentCountryCode[i]
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleTargetCode, storeType: "haggleTargetCode")
                self.homeCurrencyFlag.image = UIImage(named: UserDetails.recentCountryFlag[i])
              }
            }else{
              var CurrencySymbol = getSymbolForCurrencyCode(code: UserDetails.haggleTargetCode)//UserDetails.haggleTargetCode
              for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == UserDetails.haggleTargetCode{
                CurrencySymbol = valueArray[j]
              }
              homeCurrencyFeild.attributedPlaceholder = NSAttributedString(string: "\(CurrencySymbol)0.00",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)])
              self.homeCurrencyFlag.image = UIImage(named: UserDetails.haggleHomeIcon)
            }
          }
        }else{
          for i in 0..<(CountryNames.count){
            if cName == CountryNames[i]{
              var CurrencySymbol = getSymbolForCurrencyCode(code: CountryCodes![i])
              for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == CountryCodes![i]{
                CurrencySymbol = valueArray[j]
              }
              targetCurrencyFeild.attributedPlaceholder = NSAttributedString(string: "\(CurrencySymbol)0.00",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)])
              UserDetails.haggleHomeCode = CountryCodes![i]
              StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleHomeCode, storeType: "haggleHomeCode")
              self.targetcurrencyFlag.image = UIImage(named: CountryIcon![i])
            }
            if UserDetails.haggleHomeIcon.isEmpty{
              if UserDetails.TargetCurrency.targetCurrencyCode == CountryCodes![i]{
                var CurrencySymbol = getSymbolForCurrencyCode(code: CountryCodes![i])
                for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == CountryCodes![i]{
                  CurrencySymbol = valueArray[j]
                }
                homeCurrencyFeild.attributedPlaceholder = NSAttributedString(string: "\(CurrencySymbol)0.00",
                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)])
                UserDetails.haggleTargetCode = CountryCodes![i]
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleTargetCode, storeType: "haggleTargetCode")
                self.homeCurrencyFlag.image = UIImage(named: CountryIcon![i])
              }
            }else{
              var CurrencySymbol = getSymbolForCurrencyCode(code: UserDetails.haggleTargetCode)
              for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == UserDetails.haggleTargetCode{
                CurrencySymbol = valueArray[j]
              }
              homeCurrencyFeild.attributedPlaceholder = NSAttributedString(string: "\(CurrencySymbol)0.00",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)])
              self.homeCurrencyFlag.image = UIImage(named: UserDetails.haggleHomeIcon)
            }
          }
        }
      }
    }
  }
  
  extension HaggleMainScreen: UITextFieldDelegate{
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
        convertion(textField: textField, base: UserDetails.haggleHomeCode, target: UserDetails.haggleTargetCode, value: value)
      }
      if UserDetails.haggleHomeCode.isEmpty && UserDetails.haggleTargetCode.isEmpty{
        if !UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty{
          let code = UserDetails.ChangeHomeCurrency.homeCurrencyCode
          let tgcode = UserDetails.TargetCurrency.targetCurrencyCode
          convertion(textField: textField, base: code, target: tgcode, value: value)
        }else{
          let code = countryCode
          let tgcode = UserDetails.TargetCurrency.targetCurrencyCode
          convertion(textField: textField, base: code, target: tgcode, value: value)
        }
      }else if UserDetails.haggleHomeCode.isEmpty && !UserDetails.haggleTargetCode.isEmpty {
        let code = UserDetails.haggleTargetCode
        let tgcode = UserDetails.TargetCurrency.targetCurrencyCode
        convertion(textField: textField, base: code, target: tgcode, value: value)
      }else if UserDetails.haggleTargetCode.isEmpty && !UserDetails.haggleHomeCode.isEmpty{
        if !UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty{
          let code = UserDetails.haggleHomeCode
          let tgcode = UserDetails.ChangeHomeCurrency.homeCurrencyCode
          convertion(textField: textField, base: code, target: tgcode, value: value)
        }else{
          let code = UserDetails.haggleHomeCode
          let tgcode = countryCode
          convertion(textField: textField, base: code, target: tgcode, value: value)
        }
      }
    }
    
    @objc func hideKeyboard() {
      barView.endEditing(true)
      if  getIntValue == 1 {
        if let textValue = homeCurrencyFeild.text {
          let fillter = matches(for: RegExpression.shared.NumberRegex, in: textValue)
          getValue(homeCurrencyFeild, value: fillter.joined())
        }
      }else if getIntValue == 2 {
        if let textValue = targetCurrencyFeild.text {
          let fillter = matches(for: RegExpression.shared.NumberRegex, in: textValue)
          getValue(targetCurrencyFeild, value: fillter.joined())
        }
      }
    }
    
    func convertion(textField : UITextField,base: String,target:String,value:String){
      if !textField.text!.isNumeric{
        if !percentageScannedAmount.isEmpty,!percentageConvertedAmount.isEmpty{
          percentageScannedAmount.removeAll()
          percentageConvertedAmount.removeAll()
        }
        haggleTable.reloadData()
      }
      
      if textField == homeCurrencyFeild {
        setLoadingScreen()
        let fillter = matches(for: RegExpression.shared.NumberRegex, in: homeCurrencyFeild.text!)
        Networking.sharedInstance.convertion(baseCurrency: target, targetCurrency: base, Value: fillter.joined()) { (success, error, result) in
          if success == true{
            var symbole = self.getSymbolForCurrencyCode(code: target)
            for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == target{
                symbole = self.valueArray[j]
            }
            //        let symbole = self.getSymbolForCurrencyCode(code: target)
            var symbole1 = self.getSymbolForCurrencyCode(code: base)
            for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == base{
                symbole1 = self.valueArray[j]
            }
//            let symbole = self.getSymbolForCurrencyCode(code: target)
//            let symbole1 = self.getSymbolForCurrencyCode(code: base)
            
            self.homeCurrencyFeild.text = symbole + fillter.joined()
            self.targetCurrencyFeild.text = symbole1 + result
            self.percentage(fillter.joined(), result, symbole, symbole1, base)
          }
        }
      }else if textField == targetCurrencyFeild{
        setLoadingScreen()
        let fillter = matches(for: RegExpression.shared.NumberRegex, in: targetCurrencyFeild.text!)
        Networking.sharedInstance.convertion(baseCurrency: base, targetCurrency: target, Value: fillter.joined()) { (success, error, result) in
          if success == true{
            var symbole = self.getSymbolForCurrencyCode(code: target)
            for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == target{
                symbole = self.valueArray[j]
            }
            //        let symbole = self.getSymbolForCurrencyCode(code: target)
            var symbole1 = self.getSymbolForCurrencyCode(code: base)
            for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == base{
                symbole1 = self.valueArray[j]
            }
//            let symbole = self.getSymbolForCurrencyCode(code: target)
//            let symbole1 = self.getSymbolForCurrencyCode(code: base)
            
            self.homeCurrencyFeild.text = symbole + result
            self.targetCurrencyFeild.text = symbole1 + fillter.joined()
            self.percentage(result, fillter.joined(), symbole, symbole1, base)
          }
        }
      }
    }
    
    
    func percentage(_ scannedAmount:String, _ convertedAmount: String, _ scannedSymbole: String,_ convertedSymbole: String, _ scannedCode: String){
      if !percentageScannedAmount.isEmpty,!percentageConvertedAmount.isEmpty{
        percentageScannedAmount.removeAll()
        percentageConvertedAmount.removeAll()
      }
      let scannedDoubleValue = Double(scannedAmount)
      let convertedDoubleValue = Double(convertedAmount)
      let percentages : [Double] = [5,10,15,20,25]
      percentages.forEach { (values) in
        let fistValue = (scannedDoubleValue! * values) / 100
        let secondValue = (convertedDoubleValue! * values) / 100
        let finalFirstValue = scannedDoubleValue! - fistValue
        let finalSecondValue = convertedDoubleValue! - secondValue
        let doubleFirstStr = String(format: "%.2f", ceil(finalFirstValue*100)/100)
        let doubleSecondStr = String(format: "%.2f", ceil(finalSecondValue*100)/100)
        percentageScannedAmount.append("\(scannedSymbole) \(doubleFirstStr)")
        percentageConvertedAmount.append("\(convertedSymbole) \(doubleSecondStr)")
      }
      UserDetails.AddToWalletScannedAmount = scannedSymbole + scannedAmount
      UserDetails.PercentageCalculation.scannedAmount = scannedSymbole + scannedAmount
      UserDetails.PercentageCalculation.ConvertedAmount = convertedSymbole + convertedAmount
      UserDetails.PercentageCalculation.code = scannedCode
      scanValue = UserDetails.PercentageCalculation.scannedAmount
      convertValue = UserDetails.PercentageCalculation.ConvertedAmount
      
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.PercentageCalculation.scannedAmount, storeType: "PercentageCalculation.scannedAmount")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.PercentageCalculation.ConvertedAmount, storeType: "PercentageCalculation.ConvertedAmount")
      sellerButton.isHidden = false
      removeLoadingScreen()
      let updateValues = [scanValue,convertValue]
      UserDetails.HomeSreenUpdateValues.updateValue(updateValues, forKey: "HaggleUpdate")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
      NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
      haggleTable.reloadData()
    }
  }
  
  extension HaggleMainScreen{
    func countryCode(code: String, icon: String, identifire: Int) {
      if !code.isEmpty,!icon.isEmpty{
        if identifire == 0{
          UserDetails.haggleHomeIcon = icon
          UserDetails.haggleTargetCode = code
          //          StrongBoxController.sharedInstance.storeUserDefault(data: code, storeType: "tempCurr")
          StrongBoxController.sharedInstance.storeUserDefault(data: code, storeType: "haggleTargetCode")
          //          tempCurr = code
          StrongBoxController.sharedInstance.storeUserDefault(data: icon, storeType: "haggleHomeIcon")
          UserDetails.CountryDelegateModel.Homeicon = icon
          StrongBoxController.sharedInstance.storeUserDefault(data: icon, storeType: "CountryDelegateModel.Homeicon")
          StrongBoxController.sharedInstance.storeUserDefault(data: code, storeType: "CountryDelegateModel.Homecode")
          
          self.homeCurrencyFlag.image = UIImage(named: icon)
          if !UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty{
            let tgcode = UserDetails.ChangeHomeCurrency.homeCurrencyCode
            convertion1(base: code, target: tgcode, value: homeCurrencyFeild)
          }else{
            convertion(textField: homeCurrencyFeild, base: UserDetails.haggleHomeCode, target: code, value: homeCurrencyFeild.text!)
          }
        }
        if identifire == 1{
          //          tempCurr1 = code
          UserDetails.haggleTargetIcon = icon
          UserDetails.haggleHomeCode = code
          StrongBoxController.sharedInstance.storeUserDefault(data: icon, storeType: "haggleTargetIcon")
          //          StrongBoxController.sharedInstance.storeUserDefault(data: code, storeType: "tempCurr1")
          StrongBoxController.sharedInstance.storeUserDefault(data: code, storeType: "haggleHomeCode")
          UserDetails.CountryDelegateModel.TargetIcon = icon
          StrongBoxController.sharedInstance.storeUserDefault(data: icon, storeType: "CountryDelegateModel.TargetIcon")
          StrongBoxController.sharedInstance.storeUserDefault(data: code, storeType: "CountryDelegateModel.Targetcode")
          self.targetcurrencyFlag.image = UIImage(named: icon)
          convertion(textField: targetCurrencyFeild, base: code, target: UserDetails.haggleTargetCode, value: targetCurrencyFeild.text!)
        }
      }
    }
    
    func convertion1(base: String,target:String,value:UITextField){
      if !value.text!.isNumeric{
        if !percentageScannedAmount.isEmpty,!percentageConvertedAmount.isEmpty{
          percentageScannedAmount.removeAll()
          percentageConvertedAmount.removeAll()
        }
        haggleTable.reloadData()
      }
      if value == homeCurrencyFeild{
        setLoadingScreen()
        var symbole = self.getSymbolForCurrencyCode(code: target)
        for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == target{
            symbole = valueArray[j]
        }
//        let symbole = self.getSymbolForCurrencyCode(code: target)
        var symbole1 = self.getSymbolForCurrencyCode(code: base)
        for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == base{
            symbole1 = valueArray[j]
        }
//        let symbole1 = self.getSymbolForCurrencyCode(code: base)
        let fillter = matches(for: RegExpression.shared.NumberRegex, in: homeCurrencyFeild.text!)
        Networking.sharedInstance.convertion(baseCurrency: base, targetCurrency: target, Value: fillter.joined()) { (success, error, result) in
          if success == true{
            if !UserDetails.haggleTargetCode.isEmpty{
              self.homeCurrencyFeild.text = symbole1 + fillter.joined()
              self.targetCurrencyFeild.text = symbole + result
              self.percentage(fillter.joined(), result, symbole1, symbole, target)
            }else{
              self.homeCurrencyFeild.text = symbole1 + fillter.joined()
              self.targetCurrencyFeild.text = symbole + result
              self.percentage(fillter.joined(), result, symbole1, symbole, base)
            }
          }
        }
      }else if value == targetCurrencyFeild{
        setLoadingScreen()
        var symbole = self.getSymbolForCurrencyCode(code: target)
        for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == target{
            symbole = valueArray[j]
        }
        //        let symbole = self.getSymbolForCurrencyCode(code: target)
        var symbole1 = self.getSymbolForCurrencyCode(code: base)
        for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == base{
            symbole1 = valueArray[j]
        }
//        let symbole = self.getSymbolForCurrencyCode(code: target)
//        let symbole1 = self.getSymbolForCurrencyCode(code: base)
        let fillter = matches(for: RegExpression.shared.NumberRegex, in: targetCurrencyFeild.text!)
        Networking.sharedInstance.convertion(baseCurrency: base, targetCurrency: target, Value: fillter.joined()) { (success, error, result) in
          if success == true{
            if !UserDetails.haggleHomeCode.isEmpty{
              self.homeCurrencyFeild.text = symbole + result
              self.targetCurrencyFeild.text = symbole1 + fillter.joined()
              self.percentage(result ,fillter.joined(), symbole, symbole1, base)
            }else{
              self.targetCurrencyFeild.text = symbole1 + fillter.joined()
              self.homeCurrencyFeild.text = symbole + result
              self.percentage(result, fillter.joined() ,symbole, symbole1, base)
            }
          }
        }
      }
    }
  }
  
  
  extension HaggleMainScreen {
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
      
      // Sets the view which contains the loading text and the spinner
      let width: CGFloat = 30
      let height: CGFloat = 30
      let x = (haggleTable.frame.width / 2) - (width / 2)
      let y = (haggleTable.frame.height / 2) - (height / 2) //- (navigationController?.navigationBar.frame.height)!
      loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
      
      // Sets loading text
      // loadingLabel.textColor = .gray
      // loadingLabel.textAlignment = .center
      // loadingLabel.text = "Loading..."
      // loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
      
      // Sets spinner
      spinner.style = .gray
      spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
      spinner.startAnimating()
      
      // Adds text and spinner to the view
      loadingView.addSubview(spinner)
      // loadingView.addSubview(loadingLabel)
      haggleTable.setEmptyMessage("")
      haggleTable.addSubview(loadingView)
      
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
      
      // Hides and stops the text and the spinner
      spinner.hidesWhenStopped = true
      spinner.stopAnimating()
      spinner.isHidden = true
      // loadingLabel.isHidden = true
      
    }
  }
  
  
  extension HaggleMainScreen{
    func setUpConstraintsToAttributes(){
      switch UIDevice().type {
      case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
        barView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/2.9 + 20.0, enableInsets: true)
        
        titleLabel.layoutAnchor(top: barView.topAnchor, left: nil, bottom: nil, right: nil, centerX: barView.centerXAnchor, centerY: nil, paddingTop: 54.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
        
        backButton.layoutAnchor(top: nil, left: barView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: titleLabel.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        
        amountLabel.layoutAnchor(top: titleLabel.bottomAnchor, left: barView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 31.0, paddingLeft: 29.0, paddingBottom: 0.0, paddingRight: 0.0, width: 140.0, height: 20.0, enableInsets: true)
        
        homeCurrencyFlag.layoutAnchor(top: amountLabel.bottomAnchor, left: barView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 8.0, paddingLeft: 24.0, paddingBottom: 0.0, paddingRight: 0.0, width: 45.0, height: 45.0, enableInsets: true)
        
        homeCurrencyFeild.layoutAnchor(top: nil, left: homeCurrencyFlag.rightAnchor, bottom: nil, right: barView.rightAnchor, centerX: nil, centerY: homeCurrencyFlag.centerYAnchor, paddingTop: 0.0, paddingLeft: 14, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 46, enableInsets: true)
        
        targetcurrencyFlag.layoutAnchor(top: homeCurrencyFlag.bottomAnchor, left: homeCurrencyFlag.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 13.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 34.0, height: 34.0, enableInsets: true)
        
        targetCurrencyFeild.layoutAnchor(top: nil, left: targetcurrencyFlag.rightAnchor, bottom: nil, right: barView.rightAnchor, centerX: nil, centerY: targetcurrencyFlag.centerYAnchor, paddingTop: 0.0, paddingLeft: 20.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 31, enableInsets: true)
        
        ratesStaus.layoutAnchor(top: targetcurrencyFlag.bottomAnchor, left: barView.leftAnchor, bottom: nil, right: barView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 20, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        haggleTable.layoutAnchor(top: barView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: -10.0, paddingBottom: 20.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        sellerButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 56.0, paddingRight: 0.0, width: view.frame.size.width/1.1, height: 56.0, enableInsets: true)
      default:
        barView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/2.9, enableInsets: true)
        
        titleLabel.layoutAnchor(top: barView.topAnchor, left: nil, bottom: nil, right: nil, centerX: barView.centerXAnchor, centerY: nil, paddingTop: 34.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
        
        backButton.layoutAnchor(top: nil, left: barView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: titleLabel.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        
        amountLabel.layoutAnchor(top: titleLabel.bottomAnchor, left: barView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 31.0, paddingLeft: 29.0, paddingBottom: 0.0, paddingRight: 0.0, width: 140.0, height: 20.0, enableInsets: true)
        
        homeCurrencyFlag.layoutAnchor(top: amountLabel.bottomAnchor, left: barView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 8.0, paddingLeft: 24.0, paddingBottom: 0.0, paddingRight: 0.0, width: 45.0, height: 45.0, enableInsets: true)
        
        homeCurrencyFeild.layoutAnchor(top: nil, left: homeCurrencyFlag.rightAnchor, bottom: nil, right: barView.rightAnchor, centerX: nil, centerY: homeCurrencyFlag.centerYAnchor, paddingTop: 0.0, paddingLeft: 14, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 46, enableInsets: true)
        
        targetcurrencyFlag.layoutAnchor(top: homeCurrencyFlag.bottomAnchor, left: barView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 13.0, paddingLeft: 29.0, paddingBottom: 0.0, paddingRight: 0.0, width: 34.0, height: 34.0, enableInsets: true)
        
        targetCurrencyFeild.layoutAnchor(top: nil, left: targetcurrencyFlag.rightAnchor, bottom: nil, right: barView.rightAnchor, centerX: nil, centerY: targetcurrencyFlag.centerYAnchor, paddingTop: 0.0, paddingLeft: 20.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 31, enableInsets: true)
        
        ratesStaus.layoutAnchor(top: targetcurrencyFlag.bottomAnchor, left: barView.leftAnchor, bottom: nil, right: barView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 20, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        haggleTable.layoutAnchor(top: barView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: -10.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        sellerButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 36.0, paddingRight: 0.0, width: view.frame.size.width/1.1, height: 56.0, enableInsets: true)
      }
    }
  }
  
  

