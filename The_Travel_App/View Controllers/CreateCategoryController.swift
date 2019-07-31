//
//  CreateCategoryController.swift
//  Haggle
//
//  Created by Anil Kumar on 19/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class CreateCategoryController: UIViewController {
    
  private let categoryNavigationView = UIViewFactory()
  .build()
  
  private let categoryTitle = UILabelFactory(text: "Create Category")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  private let categoryBackButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Black_Back_Btn")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
  .build()
  
  private lazy var createCategoryMenu : UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  private let confirmButton = UIButtonFactory(title: "CONFIRM")
    .setTitileColour(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
  .build()
  
  let valueArray = RegExpression.shared.codeToSymbole.map {($0.value)}
  let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
  var symbole = String()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------CreateCategoryController------------>😀")

    if UserDetails.categoryNumber == "1"{
      categoryTitle.text = "Update Category"
    }else{
      categoryTitle.text = "Create Category"
    }
    
    
    createCategoryMenu.dataSource = self
    createCategoryMenu.delegate   = self
    createCategoryMenu.separatorStyle = .none
    createCategoryMenu.tableFooterView = UIView()
    createCategoryMenu.isScrollEnabled = false
    
    let tapgusture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(tapgusture)
    
    let tapgusture1 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    createCategoryMenu.isUserInteractionEnabled = true
    createCategoryMenu.addGestureRecognizer(tapgusture1)
    
    setUpCellRegistration()
    
    setUpLayoutViews()
  }
  
  @objc func hideKeyboard(){
    createCategoryMenu.endEditing(true)
    view.endEditing(true)
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    gradiantViewButton(confirmButton)
  }
  
  func setUpCellRegistration(){
    createCategoryMenu.register(CreateCategoryCell.self, forCellReuseIdentifier: "CreateCategoryCell")
    createCategoryMenu.register(CreateCategorybudget.self, forCellReuseIdentifier: "CreateCategorybudget")
  }
  
  @objc func backButtonTapped(){
    navigationController?.popViewController(animated: true)
  }
  
  @objc func confirmButtonTapped(){
    
    let successfullValidated = validationTextFeilds()
    
    if successfullValidated {
      if UserDetails.categoryName.isEmpty {
         navigationController?.popViewController(animated: true)
      }else{
        if UserDetails.AddToWallet.ConfirmClicked == false{
          UserDetails.AddToWallet.ConfirmClicked = true
         navigationController?.popViewController(animated: true)
        }else{
//         popOrPushToViewController("BudgetInformationController")
            navigationController?.popViewController(animated: true)
        }
      }
    }else{
      showConfirmAlert(title: "", message: "This field cannot be left blank", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
    }
  }
  
  
  func validationTextFeilds()-> Bool{
    
    let AddNameCellIndexPath = IndexPath(row: 0, section: 0)
    let nameCell: CreateCategoryCell = createCategoryMenu.cellForRow(at: AddNameCellIndexPath) as! CreateCategoryCell
    
    let ChooseCurrencyCellIndexPath = IndexPath(row: 1, section: 0)
    let budgetCell: CreateCategorybudget = createCategoryMenu.cellForRow(at: ChooseCurrencyCellIndexPath) as! CreateCategorybudget
    
    let nameCellCount = nameCell.categoryName.text?.count
    let budgetCellCount = budgetCell.categoryBudget.text?.count
    
    if nameCellCount == 0 {
      return false
    }else if budgetCellCount == 0{
      return false
    }else{
      
      let getNumber = matches(for: RegExpression.shared.NumberRegex, in: budgetCell.categoryBudget.text!)
      if !getNumber.joined().isNumeric {
        return false
      }
      
      let Name : String! = nameCell.categoryName.text
      let _ : String! = budgetCell.categoryBudget.text!
      let BudgetAmount : String! = budgetCell.categoryBudget.text!
      
      var categryList = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryList"] as! [String]
      var catagroyAmount = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryAmount"] as! [String]
      
      if UserDetails.categoryNumber == "1" {
        
        for i in 0..<categryList.count where categryList[i] == UserDetails.categoryName {
        let amount : Double! = Double(catagroyAmount[i])
          let joinedNumber = getNumber.joined()
          let categoryBudgetAmount : Double! = Double(joinedNumber)
          
          let differanceAmount = categoryBudgetAmount - amount
          print(differanceAmount)
          
          let budgetReminingDoubleArray = catagroyAmount.compactMap(Double.init)
          let budgetRemining = budgetReminingDoubleArray.reduce(0, +)
          print(budgetRemining)
          
          let tripBudget : String! = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as? String
          let totelBudgetAmount = matches(for: RegExpression.shared.NumberRegex, in: tripBudget)
          let doubleValue : Double! = Double(totelBudgetAmount.joined())
          
          let differanceInTotelBudget = doubleValue - budgetRemining
          print(differanceInTotelBudget)
          if categoryBudgetAmount > doubleValue {
            showConfirmAlert(title: "Trip Budget Exceeded", message: "This category budget would exceed the main trip budget. Please reduce and try again or increase your trip budget.", buttonTitle: "Dismiss", buttonStyle: .default, confirmAction: nil)
          }else if differanceInTotelBudget >= differanceAmount {
            if categoryBudgetAmount < amount{
              
              let arrayReg = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.reminingBudgetAmountConstant)
              let reminingBudgetDouble: Double! = Double(arrayReg.joined())
              let finalAmount = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.totelBudget)
              let totelSpendAmount: Double! = Double(finalAmount.joined())
              let diffAmountTotelSpend = totelSpendAmount - categoryBudgetAmount
              print(diffAmountTotelSpend)
              if reminingBudgetDouble >= diffAmountTotelSpend{
                catagroyAmount[i] = joinedNumber
                UserDetails.creatCategoryArray[UserDetails.budgetID]?.updateValue(catagroyAmount, forKey: "categryAmount")
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.creatCategoryArray, storeType: "creatCategoryArray")
              }else{
                showConfirmAlert(title: "Trip Budget Exceeded", message: "This category budget would exceed the main trip budget. Please reduce and try again or increase your trip budget.", buttonTitle: "Dismiss", buttonStyle: .default, confirmAction: nil)
              }
            }else{
              catagroyAmount[i] = joinedNumber
              UserDetails.creatCategoryArray[UserDetails.budgetID]?.updateValue(catagroyAmount, forKey: "categryAmount")
              StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.creatCategoryArray, storeType: "creatCategoryArray")
            }
          }else{
            showConfirmAlert(title: "Trip Budget Exceeded", message: "This category budget would exceed the main trip budget. Please reduce and try again or increase your trip budget.", buttonTitle: "Dismiss", buttonStyle: .default, confirmAction: nil)
          }
        }
      }else{
        var doubles = catagroyAmount.compactMap(Double.init)
        let amount = matches(for: RegExpression.shared.NumberRegex, in: BudgetAmount)
        
        if let joinedDoubleValue = Double(amount.joined()) {
         doubles.append(joinedDoubleValue)
        }
        
        let sum = doubles.reduce(0, +)
        let totelBudget : String! = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as? String
        let totelBudgetAmount = matches(for: RegExpression.shared.NumberRegex, in: totelBudget)
        let doubleValue : Double! = Double(totelBudgetAmount.joined())
        if sum > doubleValue {
          showConfirmAlert(title: "Exceed Category Budget", message: "Your category budget exceeds the main trip budget", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
          var catagroyAmountValue : [String] = []
          for i in 0..<(categryList.count) where categryList[i] == UserDetails.categoryName {
            catagroyAmount[i] = amount.joined()
            catagroyAmountValue = catagroyAmount
          }
          if !catagroyAmountValue.isEmpty {
            let amount = matches(for: RegExpression.shared.NumberRegex, in: BudgetAmount)
            print(amount)
            UserDetails.creatCategoryArray[UserDetails.budgetID]?.updateValue(catagroyAmountValue, forKey: "categryAmount")
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.creatCategoryArray, storeType: "creatCategoryArray")
          }else{
            let amount = matches(for: RegExpression.shared.NumberRegex, in: BudgetAmount)
            categryList.append(Name)
            catagroyAmount.append(amount.joined())
            let updatingValues = ["categryList":categryList,"categryAmount":catagroyAmount]
            UserDetails.creatCategoryArray.updateValue(updatingValues, forKey: UserDetails.budgetID)
            UserDetails.categoryWholeArray[UserDetails.budgetID]!.names.append(Name)
            StrongBoxController.sharedInstance.storeExpandableArray(array: UserDetails.categoryWholeArray, storeType: "categoryWholeArray")
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.creatCategoryArray, storeType: "creatCategoryArray")
          }
        }
      }
        let totelBudgetStore = matches(for: RegExpression.shared.NumberRegex, in: BudgetAmount)
        UserDetails.totelBudget = totelBudgetStore.joined()
      return true
    }
  }
  

  
  func setUpLayoutViews(){
    
    view.addSubview(categoryNavigationView)
    categoryNavigationView.addSubview(categoryTitle)
    categoryNavigationView.addSubview(categoryBackButton)
    view.addSubview(createCategoryMenu)
    view.addSubview(confirmButton)
    
    categoryNavigationView.bringSubviewToFront(categoryTitle)
    categoryNavigationView.bringSubviewToFront(categoryBackButton)
    view.bringSubviewToFront(createCategoryMenu)
    view.bringSubviewToFront(confirmButton)
    
    setUpConstraintsToAttributes()
  }
  
  func setUpConstraintsToAttributes(){
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      categoryNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)
      
      confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 85.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
    default:
      categoryNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
      
      confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 65.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
    }
    
    categoryTitle.layoutAnchor(top: nil, left: nil, bottom: categoryNavigationView.bottomAnchor, right: nil, centerX: categoryNavigationView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
    
    categoryBackButton.layoutAnchor(top: nil, left: categoryNavigationView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: categoryTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
    
    createCategoryMenu.layoutAnchor(top: categoryNavigationView.bottomAnchor, left: view.leftAnchor, bottom: confirmButton.topAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 50.0, paddingLeft: 17.0, paddingBottom: 50.0, paddingRight: 16.0, width: 0.0, height: 0.0, enableInsets: true)
  }
}

extension CreateCategoryController: UITableViewDelegate{
  
}

extension CreateCategoryController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0{
      let cell = tableView.dequeueReusableCell(withIdentifier: "CreateCategoryCell", for: indexPath) as! CreateCategoryCell
      cell.categoryName.delegate = self
      
      if UserDetails.categoryName.isEmpty  {
        cell.isUserInteractionEnabled = true
        cell.categoryName.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
        cell.selectionStyle = .none
      }else{
        cell.categoryName.textColor = .lightGray
        cell.categoryName.text = UserDetails.categoryName
        cell.isUserInteractionEnabled = false
      }
      return cell
    }else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CreateCategorybudget", for: indexPath) as! CreateCategorybudget
      cell.categoryBudget.delegate = self
      cell.categoryBudget.attributedPlaceholder = NSAttributedString(string: "Enter Budget",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 0.7)])
      cell.selectionStyle = .none
      let code : String! = UserDetails.shared.tripArray[UserDetails.budgetID]?["code"] as? String
      var expenseSymbol = getSymbolForCurrencyCode(code: code)
      for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == code{
        expenseSymbol = valueArray[j]
      }
      symbole = expenseSymbol
      cell.categoryBudget.text = expenseSymbol
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}

extension CreateCategoryController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
//    if UserDetails.categoryName.isEmpty {
//      let indePathValue = IndexPath(row: 1, section: 0)
//      let cell = createCategoryMenu.cellForRow(at: indePathValue) as? CreateCategorybudget
//      cell?.categoryBudget.resignFirstResponder()
//    }
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let indePathValue = IndexPath(row: 1, section: 0)
    let cell = createCategoryMenu.cellForRow(at: indePathValue) as? CreateCategorybudget
    
    if cell?.categoryBudget == textField {
      
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
      //  let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return numberOfDots <= 1 && numberOfDecimalDigits <= 2
        
//      switch string {
//      case "0","1","2","3","4","5","6","7","8","9":
//        return true
//      case ".":
//        var decimalCount = 0
//        if textField.keyboardType == .decimalPad {
//          let array = Array(textField.text!)
//          for character in array {
//            if character == "." {
//              decimalCount = decimalCount + 1
//            }
//          }
//        }
//        if decimalCount >= 1 {
//          return false
//        } else {
//          return true
//        }
//      default:
//        let array = Array(string)
//        if array.count == 0 {
//          return true
//        }
//        return false
//      }
    }else{
      return true
    }
  }
}
