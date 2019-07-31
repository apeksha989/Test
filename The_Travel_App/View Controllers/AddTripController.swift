//
//  AddTripController.swift
//  Haggle
//
//  Created by Anil Kumar on 17/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import Strongbox

class AddTripController: UIViewController , CalendarDateRangePickerViewControllerDelegate{
  
  private lazy var addTripMenu : UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  private let addTripNavigationView = UIViewFactory()
    .build()
  
  private let addTripTitle = UILabelFactory(text: "Add Trip")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
    .build()
  
  private let errorMessage = UILabelFactory(text: "You have entered an incorrect values")
    .textFonts(with: UIFont(name: "OpenSans-Regular", size: 9.0)!)
    .textColor(with: hexStringToUIColor(hex: "#00D2FF"))
    .build()
  
  let addTripBackButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Black_Back_Btn")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    .build()
  
  let confirmButton = UIButtonFactory(title: "CONFIRM")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    .build()
  
  var dates                        = String()
  lazy var firstDate = String()
  lazy var year = String()
  lazy var startDateValue = Date()
  lazy var endDateValue = Date()
  var countryIcon = String()
  var inputActive : UITextField?
  var currentDate = Date()
  let dateFormatter = DateFormatter()
  var symbole = String()
  
  lazy var calendar = CalendarDateRangePickerViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------AddTripController------------>😀")
    errorMessage.isHidden = true
    
    let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
    tapOnScreen.cancelsTouchesInView = false
    view.addGestureRecognizer(tapOnScreen)
    
    dates = ""
    addTripMenu.dataSource = self
    addTripMenu.delegate   = self
    addTripMenu.separatorStyle = .none
    addTripMenu.tableFooterView = UIView()
    addTripMenu.isScrollEnabled = false
    setUpCellRegistration()
    setUpLayoutViews()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector: #selector(BackButtonClicked(_:)), name: .BackButtonTapped, object: nil)
    countryCode(name: UserDetails.getAddtripeAttibutes.name, icon: UserDetails.getAddtripeAttibutes.icon, symbole: UserDetails.getAddtripeAttibutes.code)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    //    calendar.delegate = nil
  }
  
  @objc func donePressed(){
    view.endEditing(true)
  }
  
  
  @objc func BackButtonClicked(_ notification: Notification){
    removeData()
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    gradiantViewButton(confirmButton)
  }
  
  @objc func resignKeyboard(){
    self.view.endEditing(true)
  }
  
  func setUpCellRegistration(){
    addTripMenu.register(AddNameCell.self, forCellReuseIdentifier: "AddNameCell")
    addTripMenu.register(SelectDatesCell.self, forCellReuseIdentifier: "SelectDatesCell")
    addTripMenu.register(ChooseCurrencyCell.self, forCellReuseIdentifier: "ChooseCurrencyCell")
    addTripMenu.register(TotalBudgetCell.self, forCellReuseIdentifier: "TotalBudgetCell")
  }
  
  func setUpLayoutViews(){
    addTripMenu.tableFooterView?.addSubview(errorMessage)
    addTripMenu.tableFooterView?.bringSubviewToFront(errorMessage)
    view.addSubview(addTripNavigationView)
    addTripNavigationView.addSubview(addTripTitle)
    addTripNavigationView.addSubview(addTripBackButton)
    view.addSubview(addTripMenu)
    view.addSubview(confirmButton)
    
    addTripNavigationView.bringSubviewToFront(addTripTitle)
    addTripNavigationView.bringSubviewToFront(addTripBackButton)
    view.bringSubviewToFront(addTripMenu)
    view.bringSubviewToFront(confirmButton)
    
    setUpConstraintsToAttributes()
  }
  
  @objc func dropDownTapped(){
    if UserDetails.previousDateSelected == false {
      calendar = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
      calendar.delegate = self
      calendar.minimumDate = Date()
      calendar.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
      calendar.selectedStartDate = UserDetails.tripStartDatePreviousSelected
      calendar.selectedEndDate = UserDetails.tripEndDatePreviousSelected
      calendar.selectedColor = UIColor(red: 0.00, green: 0.82, blue: 1.00, alpha: 1)
      calendar.titleText = "Select Trip Dates"
      let navigationController = UINavigationController(rootViewController: calendar)
      self.navigationController?.present(navigationController, animated: true, completion: nil)
    }else{
      calendar = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
      calendar.delegate = self
      calendar.minimumDate = Date()
      calendar.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
      calendar.selectedStartDate = Date()
      calendar.selectedEndDate = Date()
      calendar.selectedColor = UIColor(red: 0.00, green: 0.82, blue: 1.00, alpha: 1)
      calendar.titleText = "Select Trip Dates"
      let navigationController = UINavigationController(rootViewController: calendar)
      self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
  }
  
  @objc func backButtonTapped(){
    removeData()
    if UserDetails.shared.tripArray.isEmpty {
      popOrPushToViewController("BudgetWithoutTripController")
    }else{
      navigationController?.popViewController(animated: true)
    }
  }
  func didCancelPickingDateRange() {
    calendar.delegate = nil
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  @objc func confirmButtonTapped(){
    confirmButton.loadingIndicator(show: true)
    confirmButton.setTitle("", for: .normal)
    if Reachability.isConnectedToNetwork() {
      addTripBackButton.isUserInteractionEnabled = false
      confirmButton.isUserInteractionEnabled = false
      let checkValidation = validationTextFeilds()
      if checkValidation{
        addTripBackButton.isUserInteractionEnabled = true
        confirmButton.isUserInteractionEnabled = true
        errorMessage.isHidden = true
        delay(1) { [weak self] in
       //   guard let self = self else { return }Changes made by Apeksha
            guard let `self` = self else { return }
          self.confirmButton.loadingIndicator(show: false)
          self.confirmButton.setTitle("CONFIRM", for: .normal)
          self.removeData()
          UserDetails.tripStartedFlag = false
          self.popOrPushToViewController("AllTripsController")
        }
      }else{
        addTripBackButton.isUserInteractionEnabled = true
        confirmButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 1) { [weak self] in
            //   guard let self = self else { return }Changes made by Apeksha
            guard let `self` = self else { return }
            self.confirmButton.loadingIndicator(show: false)
          self.confirmButton.setTitle("CONFIRM", for: .normal)
          self.errorMessage.isHidden = false
          self.delay(4, closure: { [weak self] in
            //   guard let self = self else { return }Changes made by Apeksha
            guard let `self` = self else { return }
            self.errorMessage.isHidden = true
          })
        }
      }
    }else{
      confirmButton.loadingIndicator(show: false)
      confirmButton.setTitle("CONFIRM", for: .normal)
      showConfirmAlert(title: "", message: "Sorry, we can't connect right now. Please check your internet connection and try again.", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
    }
  }
  
  func validationTextFeilds()-> Bool{
    dateFormatter.dateStyle = .short
    
    let AddNameCellIndexPath = IndexPath(row: 0, section: 0)
    let addcell: AddNameCell = addTripMenu.cellForRow(at: AddNameCellIndexPath) as! AddNameCell
    
    let ChooseCurrencyCellIndexPath = IndexPath(row: 2, section: 0)
    let chooseCell: ChooseCurrencyCell = addTripMenu.cellForRow(at: ChooseCurrencyCellIndexPath) as! ChooseCurrencyCell
    
    let TotalBudgetCellIndexPath = IndexPath(row: 3, section: 0)
    let totelCell: TotalBudgetCell = addTripMenu.cellForRow(at: TotalBudgetCellIndexPath) as! TotalBudgetCell
    
    let addCellCount = addcell.tripName.text?.count
    let totelCellCount = totelCell.totalBudget.text?.count
    
    if addCellCount == 0 {
      return false
    }else if chooseCell.chooseCurrency.isHidden == false{
      return false
    }else if dates.count == 0{
      return false
    }else if totelCellCount == 0{
      return false
    }else{
      
      let tripName : String! = addcell.tripName.text
      let getNumber = matches(for: RegExpression.shared.NumberRegex, in: totelCell.totalBudget.text!)
      if !getNumber.joined().isNumeric {
        return false
      }
      
      if !UserDetails.tripDate.isEmpty{
        print(startDateValue)
//        let startDate = dateFormatter.string(from: startDateValue)
//        let startDateformat = dateFormatter.date(from: startDate)
//        let startValue = startDateformat?.toLocalTime()
//        let endDate = dateFormatter.string(from: endDateValue)
//        let endDateformat = dateFormatter.date(from: endDate)
//        let endValue = endDateformat?.toLocalTime()
        
//        let startDates = UserDetails.tripDate.map {($0.value)}
//        let endDates = UserDetails.tripEndDate.map {($0.value)}
//        let endSorted =  endDates.sorted(by: { $0.compare($1) == .orderedAscending })
//        if (startDates.contains(startDateValue)) || (endDates.contains(endDateValue)) {
//          showConfirmAlert(title: "Warning", message: "Cannot create two trips on a Same Date", buttonTitle: "Dismiss", buttonStyle: .default, confirmAction: nil)
//          return false
//        }

//        for i in 0..<(startDates.count){
//          let dateVerified = startDateValue.isBetween(startDates[i], and: endDates[i])
//          if dateVerified{
//            showConfirmAlert(title: "Warning", message: "Trip Already Available on this Date", buttonTitle: "Dismiss", buttonStyle: .default, confirmAction: nil)
//            return false
//          }
//        }
//
//        for i in 0..<(endDates.count){
//          if (endSorted[i] == startValue!) || (endSorted[i] > startValue!){
//            showConfirmAlert(title: "Warning", message: "Cannot create two trips on a Same Date", buttonTitle: "Dismiss", buttonStyle: .default, confirmAction: nil)
//            return false
//          }
//        }
      }
      
      UserDetails.getAddtripeAttibutes.value = getNumber.joined()
      let totelBudjet : String = getNumber.joined() + " " + UserDetails.getAddtripeAttibutes.code
      let _ : String! = chooseCell.countryName.text
      let arrImages = ["Europe_Trip", "Asia_Trip","Europe_Trip","Asia_Trip"]
      let randomItem = Int(arc4random() % UInt32(arrImages.count))
      
      let defaultCategory = ["Food/Drink", "Tours", "Transport", "Gifts","Flights", "Shopping", "Activities","Entertainment","Accomodation","Other"]
      let updateCreatCategoryValue = ["categryList":defaultCategory,"categryAmount":[""]]
      UserDetails.creatCategoryArray.updateValue(updateCreatCategoryValue, forKey: UserDetails.tripId)
      
      let updatedValues = UserDetails.ExpandableNames(isExpanded: false, names: ["Food/Drink", "Tours", "Transport", "Gifts","Flights", "Shopping", "Activities","Entertainment","Accomodation","Other"], icons: ["Food_Category", "Tours", "Transport_Category", "Gifts_Category","Flights_Category","Shopping_Category","Activities_category","Entertainment_category", "Accomodation_Category","Other_Category"])
      UserDetails.categoryWholeArray.updateValue(updatedValues, forKey: UserDetails.tripId)
      
      let updateValue = ["tripName":tripName!,"date":firstDate,"year":year,"startData":startDateValue,"endDate":endDateValue,"countryName":UserDetails.getAddtripeAttibutes.name,"totelBudjet":totelBudjet,"backgroundImage":arrImages[randomItem],"code":UserDetails.getAddtripeAttibutes.code,"countryIcon":countryIcon] as [String : Any]
      UserDetails.shared.tripArray.updateValue(updateValue, forKey: UserDetails.tripId)
        let startDate = dateFormatter.string(from: startDateValue)
        let startDateformat = dateFormatter.date(from: startDate)
        let startValue = startDateformat?.toLocalTime()
        let endDate = dateFormatter.string(from: endDateValue)
        let endDateformat = dateFormatter.date(from: endDate)
        let endValue = endDateformat?.toLocalTime()
      UserDetails.tripDate.updateValue(startValue!, forKey: UserDetails.tripId)
      UserDetails.tripEndDate.updateValue(endValue!, forKey: UserDetails.tripId)
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.tripDate, storeType: "tripDate")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.tripEndDate, storeType: "tripEndDate")
      
      UserDetails.colorArrayRandomPicker.updateValue([:], forKey: UserDetails.tripId)
            
      let valus = UserDetails.creatCategoryArray[UserDetails.tripId]?["categryList"] as! [String]
      
      var keyValue = [String : [String]]()
      valus.forEach({ (categoryNames) in
        keyValue.updateValue([], forKey: categoryNames)
      })
      UserDetails.totalAmount.updateValue(keyValue, forKey: UserDetails.tripId)
      
      UserDetails.nameArr.removeAll()
      UserDetails.codeArr.removeAll()
      UserDetails.amountArr.removeAll()
      UserDetails.timeAgoArr.removeAll()
      UserDetails.categoryArr.removeAll()
      
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.getAddtripeAttibutes.value, storeType: "getAddtripeAttibutes.value")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.tripArray, storeType: "tripArrayStore")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.creatCategoryArray, storeType: "creatCategoryArray")
      StrongBoxController.sharedInstance.storeExpandableArray(array: UserDetails.categoryWholeArray, storeType: "categoryWholeArray")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.totalAmount, storeType: "totalAmount")
      UserDetails.tripId = UserDetails.tripId + 1
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.tripId, storeType: "tripId")
      UserDetails.newTripCreated.tripCreatedBool = true
      
      HomeScreenUpdate.shared.updateHomeScreen(self, Date())
      
//      if let key = DateValidation.sharedInstance.checkHomeScreenUpdates(Controller: self) {
//        let TotBudget = UserDetails.shared.tripArray[key]?["totelBudjet"] as? String
//        let getCode = UserDetails.shared.tripArray[key]?["code"] as? String
//        let numberOnly = self.matches(for: RegExpression.shared.NumberRegex, in: TotBudget!)
//        if UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty {
//          let countryCode = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationCode")as? String
//          convertionUpdateToHomeScreen(BaseCode: getCode!, targetCode: countryCode!, amount: numberOnly.joined(),TotalBudget: TotBudget!)
//        }else{
//          convertionUpdateToHomeScreen(BaseCode: getCode!, targetCode: UserDetails.ChangeHomeCurrency.homeCurrencyCode, amount: numberOnly.joined(),TotalBudget: TotBudget!)
//        }
//      }else{
//        let UpdateValues = ["0.00","0.00"]
//        UserDetails.HomeSreenUpdateValues.updateValue(UpdateValues, forKey: "WalletUpdate")
//        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
//      }
//      NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
      return true
    }
  }
  
//  func convertionUpdateToHomeScreen(BaseCode:String,targetCode:String,amount:String, TotalBudget: String){
//    debugPrint("<---------Convertion Sending NetWork Request From AddTripController Please Wait------------>😺")
//    var Amount = ""
//    Networking.sharedInstance.convertion(baseCurrency: BaseCode, targetCurrency: targetCode, Value: amount) { (success, error, result) in
//      if success {
//        debugPrint("<---------Convertion Success------------>😄")
////        let value = RegExpression.shared.codeToSymbole.map {($0.value)}
////        let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
//        let finalvalue = self.matches(for: RegExpression.shared.NumberRegex, in: result)
//        let tripCode = self.matches(for: RegExpression.shared.CodesRegex, in: TotalBudget)
//        let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
//        Amount = final
////        var homeSymbol = self.getSymbolForCurrencyCode(code: targetCode)
////        for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == targetCode{
////          homeSymbol = value[i]
////        }
////        for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == tripCode.joined(){
////          tripSymbol = value[i]
////        }
//        let UpdateValues = [amount+" "+tripCode.joined(),Amount+" "+targetCode]
//        UserDetails.HomeSreenUpdateValues.updateValue(UpdateValues, forKey: "WalletUpdate")
//        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
//        NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
//      }else{
//        debugPrint("<---------Failed Convertion------------>")
//        self.addTripBackButton.isUserInteractionEnabled = true
//        self.confirmButton.isUserInteractionEnabled = true
//        self.confirmButton.loadingIndicator(show: false)
//        self.confirmButton.setTitle("CONFIRM", for: .normal)
//        self.showConfirmAlert(title: "", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: { (action) in
//        })
//      }
//    }
//  }
  
  func removeData(){
    UserDetails.previousDateSelected = true
    let AddNameCellIndexPath = IndexPath(row: 0, section: 0)
    guard let addcell: AddNameCell = addTripMenu.cellForRow(at: AddNameCellIndexPath) as? AddNameCell else { return }
    
    let SelectDatesCellIndexPath = IndexPath(row: 1, section: 0)
    guard let selectDates: SelectDatesCell = addTripMenu.cellForRow(at: SelectDatesCellIndexPath) as? SelectDatesCell else { return }
    
    let ChooseCurrencyCellIndexPath = IndexPath(row: 2, section: 0)
    guard let chooseCell: ChooseCurrencyCell = addTripMenu.cellForRow(at: ChooseCurrencyCellIndexPath) as? ChooseCurrencyCell else { return }
    
    let TotalBudgetCellIndexPath = IndexPath(row: 3, section: 0)
    guard let totelCell: TotalBudgetCell = addTripMenu.cellForRow(at: TotalBudgetCellIndexPath) as? TotalBudgetCell else { return }
    
    addcell.tripName.text = ""
    selectDates.tripDates.attributedText = NSAttributedString(string: "Trip Dates",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
    dates = ""
    
    StrongBoxController.sharedInstance.removeUserDefaultValues(RetriveKey: "getAddtripeAttibutes.name")
    StrongBoxController.sharedInstance.removeUserDefaultValues(RetriveKey: "getAddtripeAttibutes.icon")
    StrongBoxController.sharedInstance.removeUserDefaultValues(RetriveKey: "getAddtripeAttibutes.code")
    
    UserDetails.getAddtripeAttibutes.name = ""
    UserDetails.getAddtripeAttibutes.icon = ""
    chooseCell.chooseCurrency.isHidden = false
    chooseCell.countryName.isHidden = true
    chooseCell.iconImage.isHidden = true
    totelCell.totalBudget.text = ""
    
  }
  
  func didPickDateRange(startDate: Date!, endDate: Date!) {
    // dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "MM/dd/yyyy"
    // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    let timeZone = TimeZone.autoupdatingCurrent.identifier as String
    dateFormatter.timeZone = TimeZone(identifier: timeZone)
    UserDetails.previousDateSelected = false
    UserDetails.tripStartDatePreviousSelected = startDate.toLocalTime()
    UserDetails.tripEndDatePreviousSelected = endDate.toLocalTime()
    firstDate = dateformate(format: "MMM dd", date: startDate) + " - " + dateformate(format: "MMM dd", date: endDate)
    year = dateformate(format: "yyyy", date: startDate)
    dates = dateformate(format: "d/MM/yy", date: startDate) + " - " + dateformate(format: "d/MM/yy", date: endDate)
    let startDates = dateFormatter.string(from: startDate)
    debugPrint("String - StartDate ---->", startDates)
    let startDateformat = dateFormatter.date(from: startDates)
    debugPrint("Date - StartDate ---->", startDateformat!)
    let endDates = dateFormatter.string(from: endDate)
    debugPrint("String - EndDate ---->", startDates)
    let endDateformat = dateFormatter.date(from: endDates)
    debugPrint("Date - EndDate ---->", endDateformat!)
    startDateValue = startDateformat!
    endDateValue = endDateformat!
    addTripMenu.reloadData()
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  func dateformate(format: String, date: Date)-> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return  dateFormatter.string(from: date)
  }
  
  func setUpConstraintsToAttributes(){
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      addTripNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)
      
      confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 85.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
    default:
      addTripNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
      
      confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 65.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
    }
    addTripTitle.layoutAnchor(top: nil, left: nil, bottom: addTripNavigationView.bottomAnchor, right: nil, centerX: addTripNavigationView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
    
    addTripBackButton.layoutAnchor(top: nil, left: addTripNavigationView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: addTripTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
    
    addTripMenu.layoutAnchor(top: addTripNavigationView.bottomAnchor, left: view.leftAnchor, bottom: confirmButton.topAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 50.0, paddingLeft: 17.0, paddingBottom: 50.0, paddingRight: 16.0, width: 0.0, height: 0.0, enableInsets: true)
    
    errorMessage.layoutAnchor(top: addTripMenu.tableFooterView?.topAnchor, left: addTripMenu.tableFooterView?.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 10.0, paddingBottom: 0.0, paddingRight: 0.0, width: (addTripMenu.tableFooterView?.frame.width)!, height: 10, enableInsets: true)
  }
}

extension AddTripController: UITableViewDelegate{
}

extension AddTripController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0{
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddNameCell", for: indexPath) as! AddNameCell
      cell.tripName.attributedPlaceholder = NSAttributedString(string: "Name",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
      cell.tripName.autocorrectionType = .no
      cell.selectionStyle = .none
      cell.tripName.addHideinputAccessoryView()
      return cell
    }else if indexPath.row == 1{
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDatesCell", for: indexPath) as! SelectDatesCell
      if dates.isEmpty {
        cell.tripDates.attributedText = NSAttributedString(string: "Trip Dates",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
      }else{
        cell.tripDates.text = dates
      }
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropDownTapped))
      cell.tripDates.isUserInteractionEnabled = true
      cell.tripDates.addGestureRecognizer(tapGesture)
      cell.selectionStyle = .none
      cell.dropDownButton.addTarget(self, action: #selector(dropDownTapped), for: .touchUpInside)
      return cell
    }else if indexPath.row == 2{
      let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCurrencyCell", for: indexPath) as! ChooseCurrencyCell
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseCurrencyTapped))
      cell.chooseCurrency.isUserInteractionEnabled = true
      
      cell.chooseCurrency.addGestureRecognizer(tapGesture)
      cell.chooseCurrency.attributedText = NSAttributedString(string: "Choose Currency",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
      cell.selectionStyle = .none
      return cell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "TotalBudgetCell", for: indexPath) as! TotalBudgetCell
      cell.totalBudget.attributedPlaceholder = NSAttributedString(string: "Enter Budget",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 0.7)])
      cell.totalBudget.delegate = self
      cell.totalBudget.autocorrectionType = .no
      cell.selectionStyle = .none
      cell.totalBudget.addHideinputAccessoryView()
      return cell
    }
  }
  @objc func chooseCurrencyTapped(){
    UserDetails.ClickBool.AddTripControllerClicked = false
    presentDissmiss(controller: "CountryViewController")
  }
  func countryCode(name: String, icon: String, symbole: String) {
    let indexPath = IndexPath.init(row: 2, section: 0)
    let budgetCellIndexPath = IndexPath.init(row: 3, section: 0)
    guard let cell = addTripMenu.cellForRow(at: indexPath) as? ChooseCurrencyCell else { return }
    guard let budgetCell = addTripMenu.cellForRow(at: budgetCellIndexPath) as? TotalBudgetCell else { return }
    if !name.isEmpty,!icon.isEmpty{
      countryIcon = icon
      cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height / 2
      cell.iconImage.layer.masksToBounds = true
      cell.countryName.isHidden = false
      cell.iconImage.isHidden = false
      cell.chooseCurrency.isHidden = true
      
      var sym = getSymbolForCurrencyCode(code: symbole)
      
      let value = RegExpression.shared.codeToSymbole.map {($0.value)}
      let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
      
      for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == symbole{
        sym = value[i]
      }
      self.symbole = sym
      budgetCell.totalBudget.text = sym
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseCurrencyTapped))
      cell.countryName.isUserInteractionEnabled = true
      cell.countryName.addGestureRecognizer(tapGesture)
      
      cell.countryName.text = name
      cell.iconImage.image = UIImage(named: icon)
    }else{
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseCurrencyTapped))
      cell.countryName.isUserInteractionEnabled = true
      cell.countryName.addGestureRecognizer(tapGesture)
      cell.iconImage.isHidden = true
      cell.countryName.isHidden = true
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 85
  }
}


class ErrorMessageClass : UILabel{
  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.text = "You have entered an incorrect values"
    self.font = UIFont(name: "OpenSans-Regular", size: 9.0)
    self.textColor = hexStringToUIColor(hex: "#00D2FF")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


extension AddTripController:UITextFieldDelegate{
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if range.length>0  && range.location == 0 {
      let changedText = NSString(string: textField.text!).substring(with: range)
      if !symbole.isEmpty {
        if changedText.contains(symbole){
          return false
        }
      }
    }
    
    guard let oldText = textField.text, let r = Range(range, in: oldText) else {
        return true
    }
    
    let newText = oldText.replacingCharacters(in: r, with: string)
    let numberOfDots = newText.components(separatedBy: ".").count - 1
    
    let numberOfDecimalDigits: Int
    if let dotIndex = newText.firstIndex(of: ".") {
        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
    } else {
        numberOfDecimalDigits = 0
    }
    return numberOfDots <= 1 && numberOfDecimalDigits <= 2
  }
  
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    let TotalBudgetCellIndexPath = IndexPath(row: 3, section: 0)
    guard let totelCell: TotalBudgetCell = addTripMenu.cellForRow(at: TotalBudgetCellIndexPath) as? TotalBudgetCell else { return }
    if textField == totelCell.totalBudget {
      inputActive = textField
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.inputActive = nil
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    var userInfo = notification.userInfo!
    if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      // Get my height size
      let myheight = addTripMenu.frame.height
      // Get the top Y point where the keyboard will finish on the view
      let keyboardEndPoint = myheight - keyboardFrame.height
      // Get the the bottom Y point of the textInput and transform it to the currentView coordinates.
      guard let inputTextFeild = inputActive else { return }
      if let pointInTable = inputTextFeild.superview?.convert(inputTextFeild.frame.origin, to: addTripMenu) {
        let textFieldBottomPoint = (pointInTable.y + inputTextFeild.frame.size.height -  100)
        // Finally check if the keyboard will cover the textInput
        if keyboardEndPoint <= textFieldBottomPoint {
          addTripMenu.contentOffset.y = textFieldBottomPoint - keyboardEndPoint
        } else {
          addTripMenu.contentOffset.y = 0
        }
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    addTripMenu.contentOffset.y = 0
  }
  
}


