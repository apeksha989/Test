//
//  CountryViewController.swift
//  popUp
//
//  Created by Anil Kumar on 15/03/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController  {
  
  var countryAndCodeAndIcon: [(currencyName:String, country:String , code: String,icon:String)] = []
  var filtered :             [(currencyName:String, country:String , code: String,icon:String)] = []
  var searchActive : Bool =  false
  let cellSpacingHeight: CGFloat = 5
  var lastContentOffset: CGFloat = 0
  var countryCodeManulInputScreen = String()
  var countryIconManulInputScreen = String()
  var countryNameManulInputScreen = String()
  var boolFlageEmptySearches = false
  
  var recentCurrencyList : [(currencyName: String, country:String , code: String,icon:String)] = []
  
  var commonCurrencyFilter : [(currencyName: String, country:String , code: String,icon:String)] = []
  
  let countrySearchBar = UISearchControllerFactory()
  .build()
  
  lazy var countryTableView : UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  lazy var dimView          = UIView(frame: UIScreen.main.bounds)  
  
  let line = UIViewFactory()
    .borderWith(value: 1.0)
    .borderColor(color: UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0))
  .build()
  
  let popView = UIViewFactory()
    .cornerRadious(value: 13)
    .backgroundColor(color: .white)
    .build()
  
  
  let closeButton = UIButtonFactory(title: "")
    .backgroundColour(with: .cyan)
    .cornerRadious(with: 20.0)
    .addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    .build()
  
  let homeLabel = UILabelFactory(text: "Change Currency")
    .textAlignment(with: .center)
    .textColor(with: .white)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
    .build()

  let currencyLabel = UILabelFactory(text: "Are you sure you would like to change your home currency?")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 18)!)
    .textColor(with: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0))
    .textAlignment(with: .center)
    .numberOf(lines: 0)
    .lineBreaking(mode: .byWordWrapping)
    .build()
  
  let yesButton = UIButtonFactory(title: "Yes")
    .setTitileColour(with: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0))
    .backgroundColour(with: .white)
    .textAlignmentButton(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 20)!)
    .addTarget(self, action: #selector(yesBtnClicked), for: .touchUpInside)
    .build()
  
  let noButton = UIButtonFactory(title: "No")
    .setTitileColour(with: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0))
    .backgroundColour(with: .white)
    .textAlignmentButton(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 20)!)
    .addTarget(self, action: #selector(noBtnClicked), for: .touchUpInside)
    .build()
  
  let imageview = UIImageFactory()
    .CornerRadious(radious: 5)
    .setImage(imageString: "PopUp_BGImage")
    .build()
  
  var counrtryNameFillter : [String] = []
  var counrtryCodeFillter : [String] = []
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------CountryViewController------------>😀")
    for i in 0..<(UserDetails.recentCountryName.count){
      recentCurrencyList.append((currencyName: UserDetails.recentCountry[i], country: UserDetails.recentCountryName[i], code: UserDetails.recentCountryCode[i], icon: UserDetails.recentCountryFlag[i]))
    }
    
    commonCurrencyFilter = recentCurrencyList
    
    closeButton.layer.masksToBounds = true
    closeButton.clipsToBounds = false
    
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    dimView.isHidden = true
    popView.isHidden = true
    
    view.addSubview(countrySearchBar)
    view.addSubview(countryTableView)
    view.addSubview(closeButton)
    view.addSubview(popView)
    popView.addSubview(imageview)
    popView.addSubview(homeLabel)
    popView.addSubview(currencyLabel)
    popView.addSubview(yesButton)
    popView.addSubview(noButton)
    popView.addSubview(line)
    view.addSubview(dimView)
    
    bringSubView(button: closeButton)
    view.bringSubviewToFront(popView)
    popView.bringSubviewToFront(imageview)
    popView.bringSubviewToFront(homeLabel)
    popView.bringSubviewToFront(currencyLabel)
    popView.bringSubviewToFront(yesButton)
    popView.bringSubviewToFront(noButton)
    popView.bringSubviewToFront(line)
    
    countrySearchBar.delegate = self
    countryTableView.dataSource = self
    countryTableView.delegate = self
    countryTableView.separatorStyle = .none
    
    setUpConstraintsToAttributes()
    setupAutoLayout()
    
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let searchTextField:UITextField = countrySearchBar.subviews[0].subviews.last as! UITextField
    searchTextField.leftView = nil
    countrySearchBar.returnKeyType = .done
    countrySearchBar.enablesReturnKeyAutomatically = true
    searchTextField.enablesReturnKeyAutomatically = true
    searchTextField.returnKeyType = .done
    countryTableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "cell")
    let textField = countrySearchBar.value(forKey: "_searchField") as? UITextField
    textField?.enablesReturnKeyAutomatically = true
    textField?.returnKeyType = .done
    textField?.clearButtonMode = .whileEditing
    textField?.textColor = UIColor(red: 0.282, green: 0.329, blue: 0.396, alpha: 1.0)
    textField?.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 242/255, alpha: 1.0)
    textField?.font = UIFont(name: "Montserrat-Medium", size: 15)
    textField?.layer.masksToBounds = true
    textField?.layer.cornerRadius = 15
    textField?.setLeftPaddingPoints(10)
    
    let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    numberToolbar.barStyle = .default
    numberToolbar.items = [
      UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))]
    numberToolbar.sizeToFit()
    textField?.inputAccessoryView = numberToolbar
    
    gradiantViewButton(closeButton)
    
    closeButton.setTitle("CLOSE", for: .normal)
    closeButton.titleLabel?.textAlignment = NSTextAlignment.center
    closeButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 14.0)
    closeButton.setTitleColor(UIColor.white, for: .normal)
  }    
  
  @objc func doneTapped(){
    view.endEditing(true)
  }

  
  func setUpConstraintsToAttributes(){
    countrySearchBar.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 70.0, paddingLeft: 20.0, paddingBottom: 0.0, paddingRight: 20.0, width: 0.0, height: 50.0, enableInsets: true)
    
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      countryTableView.layoutAnchor(top: countrySearchBar.bottomAnchor, left: countrySearchBar.leftAnchor, bottom: closeButton.topAnchor, right: countrySearchBar.rightAnchor, centerX: nil, centerY: nil, paddingTop: 20.0, paddingLeft: 0.0, paddingBottom: 10, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    default:
      countryTableView.layoutAnchor(top: countrySearchBar.bottomAnchor, left: countrySearchBar.leftAnchor, bottom: closeButton.topAnchor, right: countrySearchBar.rightAnchor, centerX: nil, centerY: nil, paddingTop: 20.0, paddingLeft: 0.0, paddingBottom: 10, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
      
    }
    
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      closeButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 50, paddingRight: 0.0, width: view.frame.size.width - 87, height: 51, enableInsets: true)
    default:
      closeButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 30, paddingRight: 0.0, width: view.frame.size.width - 87, height: 51, enableInsets: true)
    }
  }
  
  deinit {
    recentCurrencyList.removeAll()
    countryTableView.delegate = nil
    Networking.destroy()
    filtered.removeAll()
    let cell = countryTableView.dequeueReusableCell(withIdentifier: "cell") as? CountryTableViewCell
    cell?.countryIcon.image = nil
    print("Memery Leak CountryViewController")
  }
  
  @objc func closeButtonTapped(){
    if UserDetails.ClickBool.clicked == false {
      NotificationCenter.default.post(name: .BackButtonTapped, object: nil)
      dismiss(animated: true, completion: nil)
    }else if UserDetails.ClickBool.AddTripControllerClicked == false {
      dismiss(animated: true, completion: nil)
    }else{
      dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    UserDetails.delegateFlag = true
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.delegateFlag, storeType: "delegateFlag")
    requestData()
  }
  
  func requestData() {
    Networking.sharedInstance.getCountryFlags { (response, error) in
      if error != nil {
      } else if let response = response{
        self.setDataWithResponse(response: response as [DataModelItem])
      }
    }
  }
  
  func setDataWithResponse(response:[DataModelItem]){
    for res in response{
      countryAndCodeAndIcon.append((currencyName: res.currencyName! ,country: res.name!, code: res.currencyCode!,icon: res.alpha2!))
    }
    filtered = countryAndCodeAndIcon
  }
  
}
extension CountryViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section{
    case 0:
      if(searchActive) {
        return commonCurrencyFilter.count
      }else{
        return recentCurrencyList.count
      }
    case 1:
      if(searchActive) {
        return filtered.count
      } else {
        return countryAndCodeAndIcon.count
      }
    default:
      return 0
    }
  }
  
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section{
    case 0:
      return ""
    case 1:
      return "All"
    default:
      return ""
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    switch section{
    case 0:
      let headerview = UIView()
      headerview.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.0)
      return headerview
    case 1:
      let headerView = UIViewFactory()
        .clipToBounds(Bool: true)
        .masksToBounds(Bool: false)
        .shadowColor(color: UIColor(red: 0.85, green: 0.89, blue: 0.91, alpha: 0.50))
        .shadowOpacity(opaCity: 0.7)
        .shadowRadious(with: 2)
        .shadowOffset(offSetWith: 0, offSetHeignt: 5)
        .cornerRadious(value: 6)
        .borderWith(value: 1)
        .borderColor(color: UIColor(red: 0.86, green: 0.87, blue: 0.89, alpha: 0.30))
        .backgroundColor(color: UIColor(red: 234/255, green: 234/255, blue: 235/255, alpha: 1.0))
        .setAlpha(alpha: 1)
        .build()
      
      let headerLabel = UILabel(frame: CGRect(x: 30, y: 20, width:
        tableView.bounds.size.width, height: tableView.bounds.size.height))
      headerLabel.font = UIFont(name: "Verdana", size: 20)
      headerLabel.textColor = UIColor(red: 8/255, green: 67/255, blue: 100/255, alpha: 1.0)
      headerLabel.text = self.tableView(self.countryTableView, titleForHeaderInSection: section)
      headerLabel.sizeToFit()
      headerView.addSubview(headerLabel)
      
      return headerView
    default:
      let headerview = UIView()
      headerview.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.0)
      return headerview
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section{
    case 0:
      return 0
    case 1:
      return 65
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CountryTableViewCell
    
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: "cell") as? CountryTableViewCell
    }
    
    cell?.selectionStyle = .none
    cell?.countryIcon.layer.masksToBounds = true
    cell?.countryIcon.layer.cornerRadius = 15.0
    
    switch indexPath.section {
    case 0:
       if(searchActive) {
        cell?.countryIcon.image = UIImage(named: commonCurrencyFilter[indexPath.row].icon)
        cell?.currencyCodeLabel.text  = " \(commonCurrencyFilter[indexPath.row].code) - \(commonCurrencyFilter[indexPath.row].country)"
       }else{
        cell?.countryIcon.image = UIImage(named: recentCurrencyList[indexPath.row].icon)
        cell?.currencyCodeLabel.text  = " \(recentCurrencyList[indexPath.row].code) - \(recentCurrencyList[indexPath.row].country)"
       }
    case 1:
      if(searchActive) {
        cell?.countryIcon.image = UIImage(named: filtered[indexPath.row].icon)
        cell?.currencyCodeLabel.text  = " \(filtered[indexPath.row].code.uppercased()) - \(filtered[indexPath.row].currencyName)"
      }else{
        cell?.countryIcon.image = UIImage(named: countryAndCodeAndIcon[indexPath.row].icon)
        cell?.currencyCodeLabel.text  = "\(countryAndCodeAndIcon[indexPath.row].code.uppercased()) - \(countryAndCodeAndIcon[indexPath.row].currencyName)"
      }
    default:
        cell?.countryIcon.image = UIImage(named: countryAndCodeAndIcon[indexPath.row].icon)
        cell?.currencyCodeLabel.text  = "\(countryAndCodeAndIcon[indexPath.row].code.uppercased()) - \(countryAndCodeAndIcon[indexPath.row].currencyName)"
    }
    return cell!
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.section {
    case 0:
      if(searchActive) {
        
        if UserDetails.ClickBool.clicked == false {
          UserDetails.searchCountryFlag = true
        }
        
        if UserDetails.ChangeHomeCurrency.homeCurrency == false{
          UserDetails.searchCountryFlag = true
        }
        
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.searchCountryFlag, storeType: "searchCountryFlag")
        selectedCurrencyList(currencyGet: commonCurrencyFilter, indexPath: indexPath)
      }else{
        
        if UserDetails.ClickBool.clicked == false {
          UserDetails.searchCountryFlag = true
        }
        if UserDetails.ChangeHomeCurrency.homeCurrency == false{
          UserDetails.searchCountryFlag = true
        }
        
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.searchCountryFlag, storeType: "searchCountryFlag")
        selectedCurrencyList(currencyGet: recentCurrencyList, indexPath: indexPath)
      }
    default:
      if(searchActive) {
        
        if UserDetails.ClickBool.clicked == false {
          UserDetails.searchCountryFlag = false
        }
        if UserDetails.ChangeHomeCurrency.homeCurrency == false{
          UserDetails.searchCountryFlag = false
        }
        
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.searchCountryFlag, storeType: "searchCountryFlag")
        selectedCurrencyList(currencyGet: filtered, indexPath: indexPath)
      }else{
        if UserDetails.ClickBool.clicked == false {
          UserDetails.searchCountryFlag = false
        }
        
        if UserDetails.ChangeHomeCurrency.homeCurrency == false{
          UserDetails.searchCountryFlag = false
        }
        
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.searchCountryFlag, storeType: "searchCountryFlag")
        selectedCurrencyList(currencyGet: countryAndCodeAndIcon, indexPath: indexPath)
      }
    }
  }
  
  func selectedCurrencyList(currencyGet:[(currencyName: String, country:String , code: String,icon:String)],indexPath:IndexPath){
    
    if UserDetails.ClickBool.clicked == false {
      UserDetails.ClickBool.clicked = true
      
      NotificationCenter.default.post(name: .BackButtonTapped, object: nil)
      UserDetails.ChangeHomeCurrency.homeCurrencyCode = currencyGet[indexPath.row].code
      UserDetails.ChangeHomeCurrency.homeCurrencyIcon = currencyGet[indexPath.row].icon
      UserDetails.ChangeHomeCurrency.homeCurrencyName = currencyGet[indexPath.row].country
      UserDetails.haggleTargetIcon = currencyGet[indexPath.row].icon
      UserDetails.haggleHomeCode = currencyGet[indexPath.row].code
      UserDetails.haggleHomeFlagName = currencyGet[indexPath.row].country
      
      for i in 0..<(UserDetails.recentCountry.count) where UserDetails.recentCountry[i] == currencyGet[indexPath.row].country {
        UserDetails.ChangeHomeCurrency.homeCurrencyName = UserDetails.recentCountry[i]
        UserDetails.haggleHomeFlagName = UserDetails.recentCountry[i]
      }
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleTargetIcon, storeType: "haggleTargetIcon")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleHomeCode, storeType: "haggleHomeCode")
      
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.ChangeHomeCurrency.homeCurrencyCode, storeType: "ChangeHomeCurrency.homeCurrencyCode")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.ChangeHomeCurrency.homeCurrencyIcon, storeType: "ChangeHomeCurrency.homeCurrencyIcon")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.ChangeHomeCurrency.homeCurrencyName, storeType: "ChangeHomeCurrency.homeCurrencyName")
      
      
      dismiss(animated: true, completion: nil)
    }else if UserDetails.ClickBool.AddTripControllerClicked == false{
      UserDetails.ClickBool.AddTripControllerClicked = true
      doneClicked = false
        UserDetails.getAddtripeAttibutes.name = currencyGet[indexPath.row].country
        UserDetails.getAddtripeAttibutes.icon = currencyGet[indexPath.row].icon
        UserDetails.getAddtripeAttibutes.code = currencyGet[indexPath.row].code
      
      for i in 0..<(UserDetails.recentCountry.count) where UserDetails.recentCountry[i] == currencyGet[indexPath.row].country {
        UserDetails.getAddtripeAttibutes.name = UserDetails.recentCountry[i]
      }
        
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.getAddtripeAttibutes.name, storeType: "getAddtripeAttibutes.name")
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.getAddtripeAttibutes.icon, storeType: "getAddtripeAttibutes.icon")
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.getAddtripeAttibutes.code, storeType: "getAddtripeAttibutes.code")
        
        dismiss(animated: true, completion: nil)
    }else if UserDetails.ClickBool.ManualClicked == false {
     UserDetails.ClickBool.ManualClicked = true
        UserDetails.CountryDelegateModel.code = currencyGet[indexPath.row].code
        UserDetails.CountryDelegateModel.icon = currencyGet[indexPath.row].icon
        UserDetails.CountryDelegateModel.flagName = currencyGet[indexPath.row].country
        UserDetails.CountryDelegateModel.identifire = UserDetails.Identifires.shared.getSetIdentifire
        
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.CountryDelegateModel.code, storeType: "CountryDelegateModel.code")
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.CountryDelegateModel.icon, storeType: "CountryDelegateModel.icon")
        
        dismiss(animated: true, completion: nil)
    } else if UserDetails.ChangeHomeCurrency.homeCurrency == false{
      let countryCode = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationCode") as?  String
        countryCodeManulInputScreen = currencyGet[indexPath.row].code
        countryIconManulInputScreen = currencyGet[indexPath.row].icon
        countryNameManulInputScreen = currencyGet[indexPath.row].country
      
        for i in 0..<(UserDetails.recentCountry.count) where UserDetails.recentCountry[i] == currencyGet[indexPath.row].country {
          countryNameManulInputScreen = UserDetails.recentCountry[i]
        }
      
        if UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty{
          currencyLabel.text = "Your home currency has been detected as \(countryCode!).Are you sure you would like to change your home currency to \(currencyGet[indexPath.row].code)"
        }else{
          currencyLabel.text = "Your home currency has been detected as \(UserDetails.ChangeHomeCurrency.homeCurrencyCode).Are you sure you would like to change your home currency to \(currencyGet[indexPath.row].code)"
        }
        
        dimView.isHidden = false
        setView(view: popView, hidden: false)
      
    }else if UserDetails.SelectExpenseCurrencyBool.AddExpenseClicked == false{
      UserDetails.SelectExpenseCurrencyBool.AddExpenseClicked = true
      UserDetails.addExpensiveValue.code = currencyGet[indexPath.row].code
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.addExpensiveValue.code, storeType: "addExpensiveValue.code")
      dismiss(animated: true, completion: nil)
    }
    NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
  }

  
  @objc func yesBtnClicked(sender:UIButton){
    UserDetails.ChangeHomeCurrency.homeCurrency = true
    UserDetails.homeCurrencyChanged.homeCurrencyChangedBool = true
    UserDetails.ChangeHomeCurrency.homeCurrency = true
    UserDetails.ChangeHomeCurrency.homeCurrencyCode = countryCodeManulInputScreen
    UserDetails.ChangeHomeCurrency.homeCurrencyIcon = countryIconManulInputScreen
    UserDetails.ChangeHomeCurrency.homeCurrencyName = countryNameManulInputScreen
    UserDetails.haggleHomeCode                      = countryCodeManulInputScreen
    UserDetails.haggleTargetIcon                    = countryIconManulInputScreen
    
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleHomeCode, storeType: "haggleHomeCode")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleTargetIcon, storeType: "haggleTargetIcon")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.ChangeHomeCurrency.homeCurrencyCode, storeType: "ChangeHomeCurrency.homeCurrencyCode")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.ChangeHomeCurrency.homeCurrencyIcon, storeType: "ChangeHomeCurrency.homeCurrencyIcon")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.ChangeHomeCurrency.homeCurrencyName, storeType: "ChangeHomeCurrency.homeCurrencyName")
    
    dimView.isHidden = true
    setView(view: popView, hidden: true)
    NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
    dismiss(animated: true, completion: nil)
  }
  
  
  @objc func noBtnClicked(){
    dimView.isHidden = true
    setView(view: popView, hidden: true)
  }
}

extension CountryViewController: UISearchBarDelegate{
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    commonCurrencyFilter = recentCurrencyList.filter({ (data) -> Bool in
      let country: String! = data.country.lowercased()
      let code: String! = data.code
      
      if country.contains(searchText.lowercased()){
        return true
      }else if code.contains(searchText.uppercased()){
        return true
      }else {
        return false
      }
    })
    
    filtered = countryAndCodeAndIcon.filter({ (data) -> Bool in
      let country: String! = data.country.lowercased()
      let code: String! = data.code
      let currencyName: String! = data.currencyName.lowercased()
      if country.contains(searchText.lowercased())  {
        return true
      }else if code.contains(searchText.uppercased())   {
        return true
      }else if currencyName.contains(searchText.lowercased()){
        return true
      }else {
        return false
      }
    })
    
    
    if(filtered.count == 0) && (commonCurrencyFilter.count == 0){
      searchActive = false;
    } else {
      searchActive = true;
    }
    print("textDidChange")
    
    countryTableView.reloadData()
    
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    print("BeginEditing")
    
    if(filtered.count == 0) && (commonCurrencyFilter.count == 0){
      searchActive = false;
    } else {
      searchActive = true;
    }
    
    //searchActive = true;
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    print("EndEditing")
    
    if(filtered.count == 0) && (commonCurrencyFilter.count == 0){
      searchActive = false;
    } else {
      searchActive = true;
    }
    
//    searchActive = false;
    self.countrySearchBar.endEditing(true)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    print("CancelButtonClicked")
    searchActive = false;
    self.countrySearchBar.endEditing(true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("SearchButtonClicked")
//    searchActive = false;
    self.countrySearchBar.endEditing(true)
  }
}


extension CountryViewController{
  func setupAutoLayout() {
    
    popView.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: view.frame.size.width-40, height: view.frame.height/2, enableInsets: true)
    
    imageview.layoutAnchor(top: popView.topAnchor, left: popView.leftAnchor, bottom: nil, right: popView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 67, enableInsets: true)
    
    homeLabel.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: imageview.centerXAnchor, centerY: imageview.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    
    currencyLabel.layoutAnchor(top: nil, left: popView.leftAnchor, bottom: nil, right: popView.rightAnchor, centerX: nil, centerY: popView.centerYAnchor, paddingTop: 0.0, paddingLeft: 5.0, paddingBottom: 0.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
    
    yesButton.layoutAnchor(top: nil, left: popView.leftAnchor, bottom: popView.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: view.frame.width/2-21, height: 70.0, enableInsets: true)
    
    noButton.layoutAnchor(top: nil, left: nil, bottom: popView.bottomAnchor, right: popView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: view.frame.width/2-21, height: 70.0, enableInsets: true)
    
    line.layoutAnchor(top: nil, left: yesButton.rightAnchor, bottom: popView.bottomAnchor, right: noButton.leftAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 20.0, paddingRight: 0.0, width: 0.0, height: 40.0, enableInsets: true)
    
  }
}

