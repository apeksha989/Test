//
//  BudgetInformationController.swift
//  Haggle
//
//  Created by Anil Kumar on 23/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class BudgetInformationController: UIViewController {
  
  private let budgetDetailBG = UIImageFactory()
    .setImage(imageString: "Budget_Detail_BG")
    .build()
  
  private let budgetTopView = UIViewFactory()
    .build()
  
  private let budgetTitle = UILabelFactory(text: "Budget")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
  private let budgetBackButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "BackBtn")
    .setTintColor(color: .white)
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    .build()
  
  private let budgetEditButton = UIButtonFactory(title: "Edit")
    .setTitileColour(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .textFonts(with: UIFont(name: "Avenir-Medium", size: 14)!)
    .addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    .build()
  
  private let budgetName = UILabelFactory(text: "THAILAND".uppercased())
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 20)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
  private let budgetDate = UILabelFactory(text: "May 2 - May 28")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 15)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
  private let budgetYear = UILabelFactory(text: "2019")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 15)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
  private let budgetTotal = UILabelFactory(text: "Total Budget Remaining")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 10)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
  private let budgetAmount = UILabelFactory(text: "1,500 EUR")
    .adjustFontSize(Bool: true)
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 28)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
  private lazy var budgetStatistics : UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  private let tripBudget = UILabelFactory(text: "Trip Budget Remaining")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 8)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
  private let tripBudgetAmount = UILabelFactory(text: "Loading...".uppercased())
    .adjustFontSize(Bool: true)
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 21)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
  let popView = UIViewFactory()
    .cornerRadious(value: 13)
    .backgroundColor(color: .white)
    .build()
  
  let  imageview = UIImageFactory()
    .CornerRadious(radious: 5)
    .setImage(imageString: "PopUp_BGImage")
    .build()
  
  let okButton = UIButtonFactory(title: "Ok")
    .setTitileColour(with: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0))
    .textAlignmentButton(with: .center)
    .backgroundColour(with: .white)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 20)!)
    .addTarget(self, action: #selector(okBtnClicked), for: .touchUpInside)
    .build()  
  
  //Create Budget
  let titleLabel = UILabelFactory(text: "Create Budget")
    .textAlignment(with: .center)
    .textColor(with: .white)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
    .build()
  
  let DescriptionLabel = UILabelFactory(text: "Please create budget for trip categories")
    .lineBreaking(mode: .byWordWrapping)
    .numberOf(lines: 0)
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  lazy var dimView              = UIView(frame: UIScreen.main.bounds)
  
  let valueArray = RegExpression.shared.codeToSymbole.map {($0.value)}
  let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
  
  var tabBarCnt               = UITabBarController()
  var tabBarHeight            = CGFloat()
  var freshLaunch = true
  var divideTotelAmount = String()
  var loadPro = [Float]()
  var appendingAllAmount : [String] = []
  var spendEntry              = Double()
  var remainingEntry          = Double()
  var spAmount = Float()
  var reminAmount = Float()
  var totelExpense : Double? = 0.0
  var tottelSpendAmount = String()
  
  var CatagorylistArray: [String] = []
  var CategoryAmountArray: [String] = []
  var tripBudgetData = String()
  var randomColor = Int()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------BudgetInformationController------------>😀")
    totelExpense = 0.0
    budgetStatistics.delegate = self
    budgetStatistics.dataSource = self
    budgetStatistics.tableFooterView = UIView(frame: .zero)
    budgetStatistics.separatorStyle = .none
    
    self.tabBarCnt.delegate = self
    budgetStatistics.showsVerticalScrollIndicator = false
    createTabBarController()
    setUpCellRegistration()
    setUpLayoutViews()
    
    CatagorylistArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryList"] as! [String]
    CategoryAmountArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryAmount"] as! [String]
    
    if CategoryAmountArray.count == 1 || CategoryAmountArray.isEmpty {
      UserDetails.amountArray.removeAll()
      let zeroAmount = "0"
      for _ in CatagorylistArray {
        UserDetails.amountArray.append(zeroAmount)
      }
      let updatingAmountArray = ["categryList":CatagorylistArray,"categryAmount": UserDetails.amountArray]
      UserDetails.creatCategoryArray.updateValue(updatingAmountArray, forKey: UserDetails.budgetID)
      UserDetails.amountArray.removeAll()
      CatagorylistArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryList"] as! [String]
      CategoryAmountArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryAmount"] as! [String]
      
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.creatCategoryArray, storeType: "creatCategoryArray")
      setupViews()
      setupLayoutConstraints()
    }
  }
  
  func setupViews() {
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    view.addSubview(dimView)
    view.bringSubviewToFront(dimView)
    dimView.sendSubviewToBack(budgetStatistics)
    view.addSubview(popView)
    view.bringSubviewToFront(popView)
    popView.addSubview(imageview)
    popView.addSubview(DescriptionLabel)
    popView.addSubview(okButton)
    popView.bringSubviewToFront(imageview)
    imageview.addSubview(titleLabel)
    imageview.bringSubviewToFront(titleLabel)
    popView.bringSubviewToFront(DescriptionLabel)
    popView.bringSubviewToFront(okButton)
  }
  
  
  func setUpCellRegistration(){
    budgetStatistics.register(BudgetStatisticsCell.self, forCellReuseIdentifier: "BudgetStatisticsCell")
    budgetStatistics.register(BudgetHeaderCell.self, forCellReuseIdentifier: "BudgetHeaderCell")
    budgetStatistics.register(BudgetCategoriesCell.self, forCellReuseIdentifier: "BudgetCategoriesCell")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    CatagorylistArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryList"] as! [String]
    CategoryAmountArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryAmount"] as! [String]
    
    
    tripBudgetData = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as! String
    let number = matches(for: RegExpression.shared.NumberRegex, in: tripBudgetData)
    let Code = matches(for: RegExpression.shared.CodesRegex, in: tripBudgetData)
    
    if UserDetails.totalExpenseAddition.count != 0 {
      if let amount = UserDetails.totalExpenseAddition[UserDetails.budgetID] {
        totelExpense = amount.reduce(0, +)
        var symbol = getSymbolForCurrencyCode(code: Code.joined())
        let stringValue = number.joined()
        let doubleValue : Double! = Double(stringValue)
        let amount = "\(doubleValue - totelExpense!) \(Code.joined())"
        
        let finalvalue = matches(for: RegExpression.shared.NumberRegex, in: amount)
        let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
        for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == Code.joined(){
          symbol = valueArray[j]
        }
        tottelSpendAmount = "\(symbol) \(final)"
      }else{
        let codeJoined = Code.joined()
        var symbol = getSymbolForCurrencyCode(code: codeJoined)
        for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == codeJoined{
          symbol = valueArray[j]
        }
        tottelSpendAmount = "\(symbol) \(number.joined())"
      }
    }else{
      let codeJoined = Code.joined()
      var symbol = getSymbolForCurrencyCode(code: codeJoined)
      for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == codeJoined{
        symbol = valueArray[j]
      }
      tottelSpendAmount = "\(symbol) \(number.joined())"
    }
    UserDetails.categoryNumber = ""
    UserDetails.categoryName = ""
    UserDetails.totelBudget = ""
    loadingPieChart()
    budgetStatistics.scroll(to: .top, animated: true)
    if !UserDetails.creatCategoryArray.isEmpty{
      let contentOffset = budgetStatistics.contentOffset
      budgetStatistics.reloadData()
      budgetStatistics.layoutIfNeeded()
      budgetStatistics.setContentOffset(contentOffset, animated: false)
      
    }
    
    let tripName = UserDetails.shared.tripArray[UserDetails.budgetID]?["tripName"] as! String
    let tripDates = UserDetails.shared.tripArray[UserDetails.budgetID]?["date"] as! String
    let tripYear = UserDetails.shared.tripArray[UserDetails.budgetID]?["year"] as! String
    let tripCode = UserDetails.shared.tripArray[UserDetails.budgetID]?["code"] as! String
    
    budgetAmount.text = tottelSpendAmount
    budgetName.text = tripName
    budgetDate.text = tripDates
    budgetYear.text = tripYear
    
    let value = matches(for: RegExpression.shared.NumberRegex, in: tottelSpendAmount)
    let countryCode = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationCode") as? String
    if !UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty {
      DispatchQueue.global().async {
        debugPrint("<---------Convertion Sending NetWork Request From BudgetInformationController Please Wait------------>😁")
        Networking.sharedInstance.convertion(baseCurrency:  tripCode, targetCurrency: UserDetails.ChangeHomeCurrency.homeCurrencyCode, Value: value.joined()) { (success, error, result) in
          if success {
            let finalvalue = self.matches(for: RegExpression.shared.NumberRegex, in: result)
            var symbol = self.getSymbolForCurrencyCode(code: UserDetails.ChangeHomeCurrency.homeCurrencyCode)
            
            let Index = self.symboleGetArray.firstIndex { (str) -> Bool in
              str == UserDetails.ChangeHomeCurrency.homeCurrencyCode
            }
            
            if let topInt = Index {
              symbol = self.valueArray[topInt]
            }
            
//            for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == UserDetails.ChangeHomeCurrency.homeCurrencyCode{
//              symbol = self.valueArray[j]
//            }
            let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
            self.tripBudgetAmount.text = "\(symbol) \(final)"
            debugPrint("<---------Convertion Success------------>😄")
          }else{
            debugPrint("<---------Failed Convertion------------>😡")
          }
        }
      }
    }else{
      DispatchQueue.global().async {
        debugPrint("<---------Convertion Sending NetWork Request From AddTripController Please Wait------------>😁")
        Networking.sharedInstance.convertion(baseCurrency:  tripCode, targetCurrency: countryCode!, Value: value.joined()) { (success, error, result) in
          if success {
            let finalvalue = self.matches(for: RegExpression.shared.NumberRegex, in: result)
            var symbol = self.getSymbolForCurrencyCode(code: countryCode!)
            
            let Index = self.symboleGetArray.firstIndex { (str) -> Bool in
              str == countryCode
            }
            
            if let topInt = Index {
              symbol = self.valueArray[topInt]
            }
            
//            for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == countryCode!{
//              symbol = self.valueArray[j]
//            }
            let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
            self.tripBudgetAmount.text = "\(symbol) \(final)"
            debugPrint("<---------Convertion Success------------>😄")
          }else{
            debugPrint("<---------Failed Convertion------------>😡")
          }
        }
      }
    }
  }
  func reminingDatCalculation() -> String{
    
    let startDate = UserDetails.shared.tripArray[UserDetails.budgetID]?["startData"] as! Date
    let endDate = UserDetails.shared.tripArray[UserDetails.budgetID]?["endDate"] as! Date
    
    let tripStart = daysBetween(start: startDate, end: endDate)
    return String(tripStart)
  }
  
  func daysBetween(start: Date, end: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: start, to: end).day!
  }
  
  @objc func backButtonTapped(){
    navigationController?.popViewController(animated: true)
  }
  
  @objc func addNewTapped(){
    popOrPushToViewController("CreateCategoryController")
  }
  
  @objc func editButtonTapped(){
    UserDetails.editButtonTappingFlag = true
    popOrPushToViewController("EditeTripController")
  }
  
  
  @objc func okBtnClicked(){
    setView(view: popView, hidden: true)
    setView(view: dimView, hidden: true)
  }
  
  
  func setUpLayoutViews(){
    view.addSubview(budgetDetailBG)
    budgetDetailBG.addSubview(budgetTopView)
    budgetTopView.addSubview(budgetTitle)
    view.addSubview(budgetBackButton)
    view.addSubview(budgetEditButton)
    budgetDetailBG.addSubview(budgetName)
    budgetDetailBG.addSubview(budgetDate)
    budgetDetailBG.addSubview(budgetYear)
    budgetDetailBG.addSubview(budgetTotal)
    budgetDetailBG.addSubview(budgetAmount)
    view.addSubview(budgetStatistics)
    
    budgetDetailBG.addSubview(tripBudget)
    budgetDetailBG.addSubview(tripBudgetAmount)
    budgetDetailBG.bringSubviewToFront(tripBudget)
    budgetDetailBG.bringSubviewToFront(tripBudgetAmount)
    
    budgetDetailBG.bringSubviewToFront(budgetTopView)
    budgetTopView.bringSubviewToFront(budgetTitle)
    view.bringSubviewToFront(budgetBackButton)
    view.bringSubviewToFront(budgetEditButton)
    budgetDetailBG.bringSubviewToFront(budgetName)
    budgetDetailBG.bringSubviewToFront(budgetDate)
    budgetDetailBG.bringSubviewToFront(budgetYear)
    budgetDetailBG.bringSubviewToFront(budgetTotal)
    budgetDetailBG.bringSubviewToFront(budgetAmount)
    
    setUpLayoutConstraintsToAttributes()
  }
}

extension BudgetInformationController: UITabBarControllerDelegate{
  
  func createTabBarController() {
    tabBarCnt.tabBar.tintColor = UIColor.gray
    tabBarCnt.tabBar.barTintColor = UIColor.white
    self.tabBarCnt.tabBar.layer.shadowColor = UIColor.gray.cgColor
    self.tabBarCnt.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.tabBarCnt.tabBar.layer.shadowRadius = 5
    self.tabBarCnt.tabBar.layer.shadowOpacity = 0.5
    self.tabBarCnt.tabBar.layer.masksToBounds = false
    
    let firstVc = UIViewController()
    firstVc.title = "First"
    firstVc.tabBarItem = UITabBarItem(title: "View All", image: UIImage(named: "View_All_Icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "View_All_Icon")?.withRenderingMode(.alwaysOriginal))
    
    let secondVc = UIViewController()
    secondVc.title = "Third"
    secondVc.tabBarItem = UITabBarItem(title: "Add Expense", image: UIImage(named: "Add_Expense_Icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "Add_Expense_Icon")?.withRenderingMode(.alwaysOriginal))
    
    let thirdVc = UIViewController()
    thirdVc.title = "Fourth"
    thirdVc.tabBarItem = UITabBarItem(title: "New Trip", image: UIImage(named: "New_Trip_Icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "New_Trip_Icon")?.withRenderingMode(.alwaysOriginal))
    
    tabBarCnt.viewControllers = [firstVc, secondVc, thirdVc]
    
    
    let controllerArray = [firstVc, secondVc, thirdVc]
    tabBarCnt.viewControllers = controllerArray.map{ UINavigationController.init(rootViewController: $0)}
    
    self.view.addSubview(tabBarCnt.view)
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    let tabBarIndex = tabBarController.selectedIndex
    if tabBarIndex == 0 {
      popOrPushToViewController("AllTripsController")
    }else if tabBarIndex == 1{
      popOrPushToViewController("AddExpenseController")
    }else if tabBarIndex == 2{
      UserDetails.previousDateSelected = true
      UserDetails.getAddtripeAttibutes.name = ""
      UserDetails.getAddtripeAttibutes.icon = ""
      UserDetails.selectNewTrip.clickedNewTrip = false
      NotificationCenter.default.post(name: .BackButtonTapped, object: nil)
      if let addTripController = storyboardViewControllerFromString("AddTripController"){
        navigationController?.pushViewController(addTripController, animated: true)
      }
    }
  }
}

extension BudgetInformationController: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0{
      return 180.0
    }else if indexPath.row == 1{
      return 30.0
    }else{
      return 50.0
    }
  }
}

extension BudgetInformationController: UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let categoryListArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryList"] as! [String]
    return categoryListArray.count+2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let tripCode = UserDetails.shared.tripArray[UserDetails.budgetID]?["code"] as! String
    var tripSymbol = getSymbolForCurrencyCode(code: tripCode)
    
    let Index = self.symboleGetArray.firstIndex { (str) -> Bool in
      str == tripCode
    }
    
    if let topInt = Index {
      tripSymbol = self.valueArray[topInt]
    }
    
//    for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == tripCode{
//      tripSymbol = self.valueArray[j]
//    }
    if indexPath.row == 0{
      var budgetCell = tableView.dequeueReusableCell(withIdentifier: "BudgetStatisticsCell", for: indexPath) as? BudgetStatisticsCell
      
      if budgetCell == nil {
        budgetCell = BudgetStatisticsCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "BudgetStatisticsCell")
      }
      
      budgetCell?.selectionStyle = .none
      
      let finalvalue = matches(for: RegExpression.shared.NumberRegex, in: "\(totelExpense!)")
      let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
      
      budgetCell?.totalSpendAmount.text =  "\(tripSymbol) \(final)"
      budgetCell?.totalAmount.text = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as? String
      budgetCell?.daysRemaining.text = "\(reminingDatCalculation()) Days"
      
      if (UserDetails.shared.dict1[UserDetails.budgetID]?["catagoryHeaderName"]?.count == 0) || (UserDetails.shared.dict1[UserDetails.budgetID]?["catagoryHeaderName"]?.count == nil) {
        budgetCell?.setUpChartData(spendValue: 0, reminingValue: 100)
      }else{
        budgetCell?.setUpChartData(spendValue: Double(spAmount), reminingValue: Double(reminAmount))
      }
      return budgetCell!
    }else if indexPath.row == 1{
      var BudgetHeaderCellInit = tableView.dequeueReusableCell(withIdentifier: "BudgetHeaderCell", for: indexPath) as? BudgetHeaderCell
      
      if BudgetHeaderCellInit == nil {
        BudgetHeaderCellInit = BudgetHeaderCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "BudgetHeaderCell")
      }
      
      BudgetHeaderCellInit?.selectionStyle = .none
      BudgetHeaderCellInit?.addNewButton.addTarget(self, action: #selector(addNewTapped), for: .touchUpInside)
      
      return BudgetHeaderCellInit!
    }else{
      
      var Categorycell = tableView.dequeueReusableCell(withIdentifier: "BudgetCategoriesCell", for: indexPath) as? BudgetCategoriesCell
      
      if Categorycell == nil {
        Categorycell = BudgetCategoriesCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "BudgetCategoriesCell")
      }
      
      Categorycell?.selectionStyle = .none
      let Catagorylist : String! = CatagorylistArray[safe: indexPath.row-2]
      let CategoryAmount : String! = CategoryAmountArray[safe: indexPath.row-2]
      
      Categorycell?.progressView.isHidden = false
      
      if let value = UserDetails.totalAmount[UserDetails.budgetID]?[Catagorylist] {
        if !value.isEmpty {
          var totAmount : Double = 0
          value.forEach({ (tes) in
            let filter = matches(for: RegExpression.shared.NumberRegex, in: tes)
            let strValue = filter.joined()
            let resultValueDouble = Double(strValue)
            totAmount = totAmount + resultValueDouble!
          })
          if let divAmount = Double(CategoryAmount){
            let secValue : Double = (Double(totAmount) / divAmount)
            let fistValue : Double = (secValue * 100)
            let dev : Float = Float(fistValue / 100)
            
            print(UserDetails.colorArrayRandomPicker[UserDetails.budgetID]?[Catagorylist])
            
            if let value = UserDetails.colorArrayRandomPicker[UserDetails.budgetID]?[Catagorylist]{
              
              let firstGradiantColor = UIColor.color(withData: value[0])
              let secondGradiantColor = UIColor.color(withData: value[1])
              
              let colors: [CGColor] = [firstGradiantColor.cgColor,secondGradiantColor.cgColor]
              Categorycell?.progressView.gradientColors = colors
              Categorycell?.progressView.setProgress(dev, animated: false)
            }else {
              let colors: [CGColor] = [UIColor(red: 0.97, green: 0.31, blue: 0.20, alpha: 1).cgColor, UIColor(red: 0.91, green: 0.23, blue: 0.16, alpha: 1).cgColor]
              Categorycell?.progressView.gradientColors = colors
              Categorycell?.progressView.setProgress(dev, animated: false)
            }
            
          }else{
            Categorycell?.progressView.trackTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1)
            Categorycell?.progressView.gradientColors = [UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1).cgColor]
          }
        }else{
          Categorycell?.progressView.trackTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1)
          Categorycell?.progressView.gradientColors = [UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1).cgColor]
        }
      }else{
        Categorycell?.progressView.trackTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1)
        Categorycell?.progressView.gradientColors = [UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1).cgColor]
      }
      Categorycell?.isUserInteractionEnabled = true
      Categorycell?.categoryTitle.text = Catagorylist
      var tripSymbol = tripCode
      for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == tripCode{
        tripSymbol = self.valueArray[j]
      }
      Categorycell?.categoryBudget.text = "\(tripSymbol) \(CategoryAmount!)"
      return Categorycell!
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row >= 2{
      let CatagorylistArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryList"] as! [String]
      let CategoryAmountArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryAmount"] as! [String]
      
      let valueCheck = CategoryAmountArray[indexPath.row-2]
      let fillter = matches(for: RegExpression.shared.NumberRegex, in: valueCheck)
      let numbersOnly = fillter.joined()
      
      if numbersOnly == "0"{
        UserDetails.categoryNumber = "0"
        UserDetails.categoryName = CatagorylistArray[indexPath.row-2]
        UserDetails.totelBudget = CategoryAmountArray[indexPath.row-2]
        UserDetails.tot = 0
        popOrPushToViewController("CreateCategoryController")
      }else{
        UserDetails.categoryNumber = "1"
        UserDetails.categoryName = CatagorylistArray[indexPath.row-2]
        UserDetails.totelBudget = CategoryAmountArray[indexPath.row-2]
        UserDetails.tot = 0
        popOrPushToViewController("CategoryDescriptionController")
      }
    }
  }
}

extension BudgetInformationController{
  
  func setUpLayoutConstraintsToAttributes(){
    tabBarHeight = tabBarCnt.tabBar.frame.size.height + 10
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      tabBarHeight = tabBarCnt.tabBar.frame.size.height * 2
      
      budgetDetailBG.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/2.70 + 20.0, enableInsets: true)
      
      budgetTopView.layoutAnchor(top: budgetDetailBG.topAnchor, left: budgetDetailBG.leftAnchor, bottom: nil, right: budgetDetailBG.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)
      
      budgetStatistics.layoutAnchor(top: budgetDetailBG.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 20.0, paddingLeft: 20.0, paddingBottom: tabBarHeight, paddingRight: 20.0, width: 0.0, height: 0.0, enableInsets: true)
    default:
      budgetDetailBG.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/2.70, enableInsets: true)
      
      budgetStatistics.layoutAnchor(top: budgetDetailBG.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 20.0, paddingLeft: 20.0, paddingBottom: tabBarHeight, paddingRight: 20.0, width: 0.0, height: 0.0, enableInsets: true)
      
      budgetTopView.layoutAnchor(top: budgetDetailBG.topAnchor, left: budgetDetailBG.leftAnchor, bottom: nil, right: budgetDetailBG.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
    }
    budgetTitle.layoutAnchor(top: nil, left: nil, bottom: budgetTopView.bottomAnchor, right: nil, centerX: budgetTopView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
    
    budgetBackButton.layoutAnchor(top: nil, left: budgetTopView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: budgetTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 60.0, height: 60.0, enableInsets: true)
    
    budgetEditButton.layoutAnchor(top: nil, left: nil, bottom: nil, right: budgetTopView.rightAnchor, centerX: nil, centerY: budgetTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 15.0, width: 30.0, height: 18.0, enableInsets: true)
    
    budgetName.layoutAnchor(top: budgetTopView.bottomAnchor, left: budgetDetailBG.leftAnchor, bottom: nil, right: budgetDetailBG.rightAnchor, centerX: nil, centerY: nil, paddingTop: view.frame.size.height/41.69, paddingLeft: 20.0, paddingBottom: 0.0, paddingRight: 20.0, width: 0.0, height: 26.0, enableInsets: true)
    
    budgetDate.layoutAnchor(top: budgetName.bottomAnchor, left: budgetName.leftAnchor, bottom: nil, right: budgetName.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
    
    budgetYear.layoutAnchor(top: budgetDate.bottomAnchor, left: budgetName.leftAnchor, bottom: nil, right: budgetName.rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
    
    budgetTotal.layoutAnchor(top: nil, left: budgetName.leftAnchor, bottom: budgetAmount.topAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 1.0, paddingRight: 0.0, width: view.frame.size.width/2.5, height: 14.0, enableInsets: true)
    
    budgetAmount.layoutAnchor(top: nil, left: budgetName.leftAnchor, bottom: budgetDetailBG.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: view.frame.size.height/30.32, paddingRight: 0.0, width: view.frame.size.width/2.5, height: 36.0, enableInsets: true)
    
    tripBudget.layoutAnchor(top: nil, left: nil, bottom: tripBudgetAmount.topAnchor, right: tripBudgetAmount.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: view.frame.size.width/2.5, height: 11.0, enableInsets: true)
    
    tripBudgetAmount.layoutAnchor(top: nil, left: nil, bottom: budgetDetailBG.bottomAnchor, right: budgetDetailBG.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: view.frame.size.height/26.68, paddingRight: 0.0, width: view.frame.size.width/2.5, height: 26.0, enableInsets: true)
  }
  func setupLayoutConstraints(){
    
    popView.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: view.frame.size.width-40, height: view.frame.height/3, enableInsets: true)
    
    imageview.layoutAnchor(top: popView.topAnchor, left: popView.leftAnchor, bottom: nil, right: popView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 67, enableInsets: true)
    
    titleLabel.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: imageview.centerXAnchor, centerY: imageview.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    
    DescriptionLabel.layoutAnchor(top: nil, left: popView.leftAnchor, bottom: popView.bottomAnchor, right: popView.rightAnchor, centerX: popView.centerXAnchor, centerY: popView.centerYAnchor, paddingTop: 0.0, paddingLeft: 10.0, paddingBottom: 0.0, paddingRight: 10.0, width: 0.0, height: 0.0, enableInsets: true)
    
    okButton.layoutAnchor(top: nil, left: nil, bottom: popView.bottomAnchor, right: nil, centerX: popView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 5.0, paddingRight: 0.0, width: 50, height: 70, enableInsets: true)
  }
}

extension BudgetInformationController {
  
  func loadingPieChart(){
    let totelBudgetAmount = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as! String
    let all = matches(for: RegExpression.shared.NumberRegex, in: totelBudgetAmount)
    if let amt = Float(all.joined()) {
      let totalSpendAmount = amt - Float(totelExpense!)
      reminAmount = (totalSpendAmount / amt) * 100
      spAmount = (Float(totelExpense!) / amt) * 100
    }    
    budgetStatistics.reloadData()
  }
}

extension UIColor {
  class func color(withData data:Data) -> UIColor {
    return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
  }
  
  func encode() -> Data {
    return NSKeyedArchiver.archivedData(withRootObject: self)
  }
}
