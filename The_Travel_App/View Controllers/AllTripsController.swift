//
//  AllTripsController.swift
//  Haggle
//
//  Created by Anil Kumar on 19/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class AllTripsController: UIViewController {
    
  private let allTripsNavigationView = UIViewFactory()
  .build()
  
  private let allTripsTitle = UILabelFactory(text: "View All Trips")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  private let allTripsBackButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Black_Back_Btn")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
  .build()
  
  private let editButton = UIButtonFactory(title: "Edit")
    .setTitileColour(with: UIColor(red: 0.01, green: 0.59, blue: 0.85, alpha: 1))
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
  .build()
  
  private let doneButton = UIButtonFactory(title: "Done")
    .setTitileColour(with: UIColor(red: 0.01, green: 0.59, blue: 0.85, alpha: 1))
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
  .build()
  
  private lazy var allTripsTable : UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  private let popUpView = UIViewFactory()
    .cornerRadious(value: 13)
    .backgroundColor(color: .white)
  .build()
  
  private let popUpImage = UIImageFactory()
    .setImage(imageString: "PopUp_BGImage")
    .CornerRadious(radious: 5)
  .build()
  
  private let popUpTitle = UILabelFactory(text: "Delete Items")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  private let popUpDescription =  UILabelFactory(text: "Are you sure you would like to delete these items?")
    .lineBreaking(mode: .byWordWrapping)
    .numberOf(lines: 0)
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  private let popUpYes = UIButtonFactory(title: "Yes")
    .setTitileColour(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
    .textAlignmentButton(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 20)!)
    .backgroundColour(with: .white)
    .addTarget(self, action: #selector(yesBtnClicked), for: .touchUpInside)
  .build()
  
  private let popUpNo = UIButtonFactory(title: "No")
    .backgroundColour(with: .white)
    .textAlignmentButton(with: .center)
    .setTitileColour(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 20)!)
    .addTarget(self, action: #selector(noBtnClicked), for: .touchUpInside)
  .build()
  
  private let confirmButton = UIButtonFactory(title: "CREATE TRIP")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
    .build()
  
  
  private lazy var dimView                  =  UIView(frame: UIScreen.main.bounds)
  var closeIcon                     =  false
  var index                         =  Int()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------AllTripsController------------>😀")
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    dimView.isHidden = true
    allTripsTable.dataSource = self
    allTripsTable.delegate   = self
    allTripsTable.separatorStyle = .none
    allTripsTable.tableFooterView = UIView()
    allTripsTable.showsVerticalScrollIndicator = false
    doneButton.isHidden = true
    popUpView.isHidden  = true
    
    setUpCellRegistration()
    setUpLayoutViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    allTripsTable.scroll(to: .top, animated: true)
    allTripsTable.reloadData()
  }
  func setUpCellRegistration(){
    allTripsTable.register(AllTripsViewCell.self, forCellReuseIdentifier: "AllTripsViewCell")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    closeIcon = false
    doneButton.isHidden = true
    editButton.isHidden = false
  }
  
  @objc func backButtonTapped(){
    popOrPushToViewController("WalletMainController")
  }
  
  @objc func editButtonTapped(){
    closeIcon = true
    editButton.isHidden = true
    doneButton.isHidden = false
    allTripsTable.reloadData()
  }
  
  @objc func doneButtonTapped(){
    closeIcon = false
    doneButton.isHidden = true
    editButton.isHidden = false
    allTripsTable.reloadData()
  }
  
  @objc func yesBtnClicked(sender:UIButton){
    
    UserDetails.creatCategoryArray.removeValue(forKey: index)
    UserDetails.shared.dict1.removeValue(forKey: index)
    UserDetails.categoryWholeArray.removeValue(forKey: index)
    UserDetails.shared.tripArray.removeValue(forKey: index)//remove(at: index)
    UserDetails.totalAmount.removeValue(forKey: index)
    UserDetails.totalExpenseAddition.removeValue(forKey: index)
    UserDetails.tripDate.removeValue(forKey: index)
    UserDetails.colorArrayRandomPicker.removeValue(forKey: index)
    UserDetails.tripEndDate.removeValue(forKey: index)
//    if !UserDetails.shared.notificationArray.isEmpty{
//      UserDetails.shared.notificationArray.remove(at: index)
//    }
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.notificationArray, storeType: "notificationArray")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.colorArrayRandomPicker, storeType: "colorArrayRandomPicker")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.totalExpenseAddition, storeType: "totalExpenseAddition")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.tripDate, storeType: "tripDate")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.tripEndDate, storeType: "tripEndDate")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.dict1, storeType: "dict1")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.tripArray, storeType: "tripArrayStore")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.creatCategoryArray, storeType: "creatCategoryArray")
    StrongBoxController.sharedInstance.storeExpandableArray(array: UserDetails.categoryWholeArray, storeType: "categoryWholeArray")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.totalAmount, storeType: "totalAmount")
    
    if UserDetails.shared.tripArray.isEmpty {
        UserDetails.colorArrayRandomPicker.removeAll()
        UserDetails.totalExpenseAddition.removeAll()
        UserDetails.tripDate.removeAll()
        UserDetails.tripEndDate.removeAll()
        UserDetails.tripId = 0
        UserDetails.creatCategoryArray.removeAll()
        UserDetails.shared.dict1.removeAll()
        UserDetails.categoryWholeArray.removeAll()
      
        if !UserDetails.shared.notificationArray.isEmpty{
          UserDetails.shared.notificationArray.removeAll()
        }
      
        UserDetails.getAddtripeAttibutes.name = ""
        UserDetails.getAddtripeAttibutes.icon = ""
        UserDetails.previousDateSelected = true
        UserDetails.selectNewTrip.clickedNewTrip = true
        NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
      
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.notificationArray, storeType: "notificationArray")
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.colorArrayRandomPicker, storeType: "colorArrayRandomPicker")
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.totalExpenseAddition, storeType: "totalExpenseAddition")
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.tripDate, storeType: "tripDate")
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.tripEndDate, storeType: "tripEndDate")
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.tripId, storeType: "tripId")
        popOrPushToViewController("BudgetWithoutTripController")
    }else{
      if let key = DateValidation.sharedInstance.checkHomeScreenUpdates(Controller: self, currentDate: Date()) {
            let TotBudget = UserDetails.shared.tripArray[key]?["totelBudjet"] as? String
            let getCode = UserDetails.shared.tripArray[key]?["code"] as? String
            let numberOnly = self.matches(for: RegExpression.shared.NumberRegex, in: TotBudget!)
            if UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty {
                let countryCode = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationCode")as? String
                convertionUpdateToHomeScreen(BaseCode: getCode!, targetCode: countryCode!, amount: numberOnly.joined(),TotalBudget: TotBudget!)
            }else{
                convertionUpdateToHomeScreen(BaseCode: getCode!, targetCode: UserDetails.ChangeHomeCurrency.homeCurrencyCode, amount: numberOnly.joined(),TotalBudget: TotBudget!)
            }
        }else{
            let UpdateValues = ["0.00","0.00"]
            UserDetails.HomeSreenUpdateValues.updateValue(UpdateValues, forKey: "WalletUpdate")
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
        }
        NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
        allTripsTable.reloadData()
    }
    NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
    dimView.isHidden = true
    setView(view: popUpView, hidden: true)
    }
    
    func convertionUpdateToHomeScreen(BaseCode:String,targetCode:String,amount:String, TotalBudget: String){
        debugPrint("<---------Convertion Sending NetWork Request From AddTripController Please Wait------------>😺")
        var Amount = ""
        Networking.sharedInstance.convertion(baseCurrency: BaseCode, targetCurrency: targetCode, Value: amount) { (success, error, result) in
            if success {
                debugPrint("<---------Convertion Success------------>😄")
                //        let value = RegExpression.shared.codeToSymbole.map {($0.value)}
                //        let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
                let finalvalue = self.matches(for: RegExpression.shared.NumberRegex, in: result)
                let tripCode = self.matches(for: RegExpression.shared.CodesRegex, in: TotalBudget)
                let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
                Amount = final
                //        var homeSymbol = self.getSymbolForCurrencyCode(code: targetCode)
                //        for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == targetCode{
                //          homeSymbol = value[i]
                //        }
                //        for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == tripCode.joined(){
                //          tripSymbol = value[i]
                //        }
                let UpdateValues = [amount+" "+tripCode.joined(),Amount+" "+targetCode]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateValues, forKey: "WalletUpdate")
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
                NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
            }else{
                debugPrint("<---------Failed Convertion------------>")
                self.showConfirmAlert(title: "", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: { (action) in
                })
            }
        }
    }
    
  @objc func confirmBtnTapped(){
    if let navigation = storyboardViewControllerFromString("AddTripController") as? AddTripController {
      navigationController?.pushViewController(navigation, animated: true)
    }
//    popOrPushToViewController("AddTripController")
  }
  @objc func noBtnClicked(){
    dimView.isHidden = true
    setView(view: popUpView, hidden: true)
    allTripsTable.reloadData()
  }
  
  
  @objc func deleteButtonTapped(sender:UIButton) {
    index = sender.tag
    print(index)
    dimView.isHidden = false
    setView(view: popUpView, hidden: false)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    gradiantViewButton(confirmButton)
  }
  
  func setUpLayoutViews(){
    
    view.addSubview(allTripsNavigationView)
    allTripsNavigationView.addSubview(allTripsTitle)
    allTripsNavigationView.addSubview(allTripsBackButton)
    allTripsNavigationView.addSubview(editButton)
    allTripsNavigationView.addSubview(doneButton)
    view.addSubview(allTripsTable)
    view.addSubview(confirmButton)
//    allTripsTable.bringSubviewToFront(confirmButton)
    view.addSubview(popUpView)
    popUpView.addSubview(popUpImage)
    popUpView.addSubview(popUpTitle)
    popUpView.addSubview(popUpDescription)
    popUpView.addSubview(popUpYes)
    popUpView.addSubview(popUpNo)
    view.addSubview(dimView)
    
    allTripsNavigationView.bringSubviewToFront(allTripsTitle)
    allTripsNavigationView.bringSubviewToFront(allTripsBackButton)
    allTripsNavigationView.bringSubviewToFront(editButton)
    allTripsNavigationView.bringSubviewToFront(doneButton)
    view.bringSubviewToFront(popUpView)
    popUpView.bringSubviewToFront(popUpImage)
    popUpView.bringSubviewToFront(popUpTitle)
    popUpView.bringSubviewToFront(popUpDescription)
    popUpView.bringSubviewToFront(popUpYes)
    popUpView.bringSubviewToFront(popUpNo)
    
    setUpConstraintsToAttributes()
  }
  
  func setUpConstraintsToAttributes(){
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      allTripsNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)

      confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 45, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
    default:
      allTripsNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
      
       confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 25, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
    }
    allTripsTitle.layoutAnchor(top: nil, left: nil, bottom: allTripsNavigationView.bottomAnchor, right: nil, centerX: allTripsNavigationView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
    
    allTripsBackButton.layoutAnchor(top: nil, left: allTripsNavigationView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: allTripsTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
    
    editButton.layoutAnchor(top: nil, left: nil, bottom: nil, right: allTripsNavigationView.rightAnchor, centerX: nil, centerY: allTripsTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 15.0, width: 30.0, height: 18.0, enableInsets: true)
    
    doneButton.layoutAnchor(top: nil, left: nil, bottom: nil, right: allTripsNavigationView.rightAnchor, centerX: nil, centerY: allTripsTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 15.0, width: 40.0, height: 18.0, enableInsets: true)
    
    allTripsTable.layoutAnchor(top: allTripsNavigationView.bottomAnchor, left: view.leftAnchor, bottom: confirmButton.topAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 20, paddingLeft: 15.0, paddingBottom: 10.0, paddingRight: 15.0, width: 0.0, height: 0.0, enableInsets: true)
    
    popUpView.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: view.frame.size.width - 50, height: view.frame.size.height/2.91, enableInsets: true)
    
    popUpImage.layoutAnchor(top: popUpView.topAnchor, left: popUpView.leftAnchor, bottom: nil, right: popUpView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 67, enableInsets: true)
    
    popUpTitle.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: popUpImage.centerXAnchor, centerY: popUpImage.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    
    popUpDescription.layoutAnchor(top: nil, left: popUpView.leftAnchor, bottom: nil, right: popUpView.rightAnchor, centerX: nil, centerY: popUpView.centerYAnchor, paddingTop: 0.0, paddingLeft: 25.0, paddingBottom: 0.0, paddingRight: 25.0, width: 0.0, height: 0.0, enableInsets: true)
    
    popUpYes.layoutAnchor(top: nil, left: popUpView.leftAnchor, bottom: popUpView.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: view.frame.width/2-25, height: 70.0, enableInsets: true)
    
    popUpNo.layoutAnchor(top: nil, left: nil, bottom: popUpView.bottomAnchor, right: popUpView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: view.frame.width/2-25, height: 70.0, enableInsets: true)
  }
}

extension AllTripsController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.bounds.height/2.5
  }
}

extension AllTripsController: UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if UserDetails.shared.tripArray.isEmpty {
      return 0
    }else{
      return UserDetails.shared.tripArray.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AllTripsViewCell", for: indexPath) as! AllTripsViewCell
    
    let key = UserDetails.shared.tripArray.map {($0.key)}
    
    let sortedTripArray = UserDetails.shared.tripArray.sorted { (aDic, bDic) -> Bool in
      return aDic.key < bDic.key
    }
    let Allvalue = sortedTripArray[indexPath.row].value
    let tripName = Allvalue["tripName"] as! String
    let tripImage = Allvalue["backgroundImage"] as! String
    let tripDates = Allvalue["date"] as! String
    let tripYear = Allvalue["year"] as! String
    let totalTripCode = Allvalue["code"] as! String
    
    cell.tripImage.image      = UIImage(named: tripImage)
    cell.tripName.text        = tripName
    cell.tripDates.text       = tripDates
    cell.tripYear.text        = tripYear
    
    var CurrencySymbol = getSymbolForCurrencyCode(code: totalTripCode)
    
    let value = RegExpression.shared.codeToSymbole.map {($0.value)}
    let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
    
    for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == totalTripCode{
      CurrencySymbol = value[i]
    }
    
    if UserDetails.totalExpenseAddition.count != 0 {
      if let amount = UserDetails.totalExpenseAddition[indexPath.row] {
        let totelExpense = amount.reduce(0, +)
        
        cell.totalTripAmount.text = "\(CurrencySymbol) \(Int(totelExpense))"
      }else{
        cell.totalTripAmount.text = "\(CurrencySymbol) 0.00"
      }
    }else{
      cell.totalTripAmount.text = "\(CurrencySymbol) 0.00"
    }
            
    if closeIcon == false{
      cell.closeButton.isHidden = true
    }else{
        cell.closeButton.isHidden = false      
      let keySort = key.sorted()
      cell.closeButton.tag = keySort[indexPath.row]
      cell.closeButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    cell.selectionStyle = .none
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if closeIcon == false{

      let sortedTripArray = UserDetails.shared.tripArray.sorted { (aDic, bDic) -> Bool in
        return aDic.key < bDic.key
      }
      UserDetails.shared.tripBudgetConvertionAmount = ""
      UserDetails.budgetID = sortedTripArray[indexPath.row].key
     popOrPushToViewController("BudgetInformationController")
    }
  }
}

