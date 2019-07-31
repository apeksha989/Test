//
//  AddExpenseController.swift
//  Haggle
//
//  Created by Anil Kumar on 25/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class AddExpenseController: UIViewController, UITextFieldDelegate, popUDelegate {

  private lazy var dimView              = UIView(frame: UIScreen.main.bounds)

  private let topView = UIViewFactory()
  .build()
    
  private let addExpenseTitle = UILabelFactory(text: "Add Expense")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  private let addExpenseBackButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Black_Back_Btn")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
  .build()
  
  private let buttonContainer = UIViewFactory()
  .build()
  
  private let confirmButton = UIButtonFactory(title: "CONFIRM")
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .setTitileColour(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .addTarget(self, action: #selector(didTabAddExpenseConfirmButton), for: .touchUpInside)
  .build()
  
  private lazy var addExpenseTable : UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  private let popUpView = UIViewFactory()
    .cornerRadious(value: 13)
    .backgroundColor(color: .white)
  .build()
  
  private let popUpBGImage = UIImageFactory()
    .CornerRadious(radious: 5)
    .setImage(imageString: "PopUp_BGImage")
  .build()
  
  private let popUpTitle = UILabelFactory(text: "Create Category")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  private let categoryNameTextBox = UITextFieldFactory()
    .setFont(font: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(color: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
    
  private let categoryBudgetText = UITextFieldFactory()
    .setFont(font: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(color: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
    .build()

  private let popUpconfirmButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "BG_Button")
    .setContendMode(Mode: .scaleToFill)
    .addTarget(self, action: #selector(didTabPopUpConfirmButton), for: .touchUpInside)
  .build()
  
  private let cancelButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "dimView_cancel")
    .addTarget(self, action: #selector(didTabCancel), for: .touchUpInside)
  .build()

  
    let numberToolbar             = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    var sectionValue              = Int()
    var categoryHeaderName              = ""
    var name                      = String()
    var expense                   = String()
    var inputActive   : UITextField?
    var notificationReminingAmount = String()
  
    let valueArray = RegExpression.shared.codeToSymbole.map {($0.value)}
    let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
    
    var walletExpands: UserDetails.ExpandableNames?
    var symbole = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      debugPrint("<---------AddExpenseController------------>😀")
        walletExpands = UserDetails.categoryWholeArray[UserDetails.budgetID]
        
        categoryHeaderName = (walletExpands?.names.first)!
        
        UserDetails.addExpensiveValue.code = UserDetails.shared.tripArray[UserDetails.budgetID]?["code"] as! String
        
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        dimView.isHidden = true
        popUpView.isHidden  = true
        categoryNameTextBox.delegate = self
        categoryBudgetText.delegate = self
        cancelButton.isHidden = true
        
        addExpenseTable.dataSource = self
        addExpenseTable.delegate   = self
        addExpenseTable.separatorStyle = .none
        
        categoryNameTextBox.attributedPlaceholder = NSAttributedString(string: "Category Name",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
        categoryBudgetText.attributedPlaceholder = NSAttributedString(string: "Category Budget",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
        categoryBudgetText.keyboardType = .decimalPad
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTabDoneBarButton))]
        numberToolbar.sizeToFit()
        categoryBudgetText.inputAccessoryView = numberToolbar
        categoryBudgetText.adjustsFontSizeToFitWidth = true
        categoryNameTextBox.adjustsFontSizeToFitWidth = true
        
        cancelButton.addTarget(self, action: #selector(didTabCancel), for: .touchUpInside)
        
        setUpCellRegistration()
        setUpLayoutViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func didTabCancel(){
        setView(view: popUpView, hidden: true)
        dimView.isHidden = true
        cancelButton.isHidden = true
    }
    
    @objc func didTabDoneBarButton(){
        categoryBudgetText.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        buttonContainer.layer.cornerRadius = 25
        buttonContainer.layer.shadowColor = UIColor(red: 0.12, green: 0.03, blue: 0.27, alpha: 0.20).cgColor
        buttonContainer.layer.shadowOpacity = 0.5
        buttonContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        gradiantViewButton(confirmButton)
        popUpconfirmButton.clipsToBounds = true
        popUpconfirmButton.layer.cornerRadius = 23.0
        
        setUpConstraintsToLayoutAttributes()
    }
    
    func setUpCellRegistration(){
        addExpenseTable.register(CategoryDropDownViewCell.self, forCellReuseIdentifier: "CategoryDropDownViewCell")
        addExpenseTable.register(AddExpenseCategoryCell.self, forCellReuseIdentifier: "AddExpenseCategoryCell")
        addExpenseTable.register(AddExpenseWithoutDropDownCell.self, forCellReuseIdentifier: "AddExpenseWithoutDropDownCell")  //AddExpenseCategoryNameCell
        addExpenseTable.register(AddExpenseCategoryNameCell.self, forCellReuseIdentifier: "AddExpenseCategoryNameCell")
    }
    
    @objc func backButtonTapped(){
        if UserDetails.AddToWallet.WalletBackClicked == false {
            UserDetails.AddToWallet.WalletBackClicked = true
            UserDetails.AddToWallet.WalletClicked = true
            navigationController?.popViewController(animated: true)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        addExpenseTable.reloadData()
    }
    func setUpLayoutViews(){
        view.addSubview(topView)
        topView.addSubview(addExpenseTitle)
        topView.addSubview(addExpenseBackButton)
        view.addSubview(addExpenseTable)
        view.addSubview(buttonContainer)
        buttonContainer.addSubview(confirmButton)
        view.addSubview(popUpView)
        popUpView.addSubview(popUpBGImage)
        popUpView.addSubview(popUpTitle)
        popUpView.addSubview(categoryNameTextBox)
        popUpView.addSubview(categoryBudgetText)
        popUpView.addSubview(popUpconfirmButton)
        view.addSubview(dimView)
        view.addSubview(cancelButton)
        
        view.bringSubviewToFront(topView)
        topView.bringSubviewToFront(addExpenseTitle)
        view.bringSubviewToFront(addExpenseBackButton)
        buttonContainer.bringSubviewToFront(confirmButton)
        view.bringSubviewToFront(popUpView)
        popUpView.bringSubviewToFront(popUpBGImage)
        popUpView.bringSubviewToFront(popUpTitle)
        popUpView.bringSubviewToFront(categoryNameTextBox)
        popUpView.bringSubviewToFront(categoryBudgetText)
        view.bringSubviewToFront(popUpconfirmButton)
        view.bringSubviewToFront(cancelButton)
    }
    
    func setUpConstraintsToLayoutAttributes(){
        switch UIDevice().type {
        case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
            topView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)
            
            buttonContainer.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 63.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
            
            confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 63.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
        default:
            topView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
            
            buttonContainer.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 43.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
            
            confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 43.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
        }
        addExpenseTitle.layoutAnchor(top: nil, left: nil, bottom: topView.bottomAnchor, right: nil, centerX: topView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
        
        addExpenseBackButton.layoutAnchor(top: nil, left: topView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: addExpenseTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        
        addExpenseTable.layoutAnchor(top: topView.bottomAnchor, left: view.leftAnchor, bottom: confirmButton.topAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 45.0, paddingLeft: 10.0, paddingBottom: 10.0, paddingRight: 10.0, width: 0.0, height: 0.0, enableInsets: true)
        
        popUpView.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: view.frame.size.width - 50, height: view.frame.size.height/2, enableInsets: true)
        
        popUpBGImage.layoutAnchor(top: popUpView.topAnchor, left: popUpView.leftAnchor, bottom: nil, right: popUpView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 67, enableInsets: true)
        
        popUpTitle.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: popUpBGImage.centerXAnchor, centerY: popUpBGImage.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        categoryNameTextBox.layoutAnchor(top: popUpBGImage.bottomAnchor, left: popUpView.leftAnchor, bottom: nil, right: popUpView.rightAnchor, centerX: popUpView.centerXAnchor, centerY: nil, paddingTop: 30.0, paddingLeft: 25.0, paddingBottom: 0.0, paddingRight: 25.0, width: 0.0, height: 45.0, enableInsets: true)
        
        categoryBudgetText.layoutAnchor(top: categoryNameTextBox.bottomAnchor, left: popUpView.leftAnchor, bottom: nil, right: popUpView.rightAnchor, centerX: popUpView.centerXAnchor, centerY: nil, paddingTop: 20.0, paddingLeft: 25.0, paddingBottom: 0.0, paddingRight: 25.0, width: 0.0, height: 45.0, enableInsets: true)
        
        popUpconfirmButton.layoutAnchor(top: nil, left: nil, bottom: popUpView.bottomAnchor, right: nil, centerX: popUpView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 28.0, paddingRight: 0.0, width: popUpView.frame.size.width/1.17, height: 50.0, enableInsets: true)
        
        cancelButton.layoutAnchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 42.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 23.0, width: 20.0, height: 20.0, enableInsets: true)
    }
}

extension AddExpenseController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if !walletExpands!.isExpanded{
                return 0
            }
            return (walletExpands?.names.count)!
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDropDownViewCell", for: indexPath) as! CategoryDropDownViewCell
            
            let name  = walletExpands?.names[safe: indexPath.row]
            let image = walletExpands?.icons[safe: indexPath.row]
            
            cell.selectionStyle = .none
            cell.categoryName.text = name
            if image == nil{
                cell.categoryIcons.image = UIImage(named: "Other_Category")
            }else{
                cell.categoryIcons.image = UIImage(named: image!)
            }
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddExpenseCategoryCell", for: indexPath) as! AddExpenseCategoryCell
              if UserDetails.AddToWallet.WalletClicked == false{
                let code = UserDetails.shared.tripArray[UserDetails.budgetID]?["code"] as! String
                cell.expenseTextField.text = code
                cell.isUserInteractionEnabled = false
              }else{
                if !UserDetails.addExpensiveValue.code.isEmpty{
                  let expenseSymbol = UserDetails.addExpensiveValue.code
                  cell.expenseTextField.text = expenseSymbol
                }else{
                  let expenseSymbol = UserDetails.addExpensiveValue.code
                  cell.expenseTextField.text = expenseSymbol
                }
                cell.isUserInteractionEnabled = true
              }
              
                cell.expenseTextField.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(selectCurrencyTapped))
                let tap1 = UITapGestureRecognizer(target: self, action: #selector(selectCurrencyTapped))
                cell.expenseTextField.addGestureRecognizer(tap1)
                cell.addGestureRecognizer(tap)
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddExpenseCategoryNameCell", for: indexPath) as! AddExpenseCategoryNameCell
                cell.expenseTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
                cell.isUserInteractionEnabled = true
                cell.selectionStyle = .none
                cell.expenseTextField.keyboardType = .alphabet
                name = cell.expenseTextField.text!
                print("name------>", name)
                if !name.isEmpty {
                    cell.expenseTextField.text = name
                }else{
                    cell.expenseTextField.text = ""
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddExpenseWithoutDropDownCell", for: indexPath) as! AddExpenseWithoutDropDownCell
                if UserDetails.AddToWallet.WalletClicked == false{
                    let finalValue = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.AddToWalletScannedAmount)
                    cell.expenseTextField.text = finalValue.joined()
                }else{
                    cell.expenseTextField.attributedPlaceholder = NSAttributedString(string: "0.00",
                                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
                    expense = cell.expenseTextField.text!
                  print("expense------>", expense)
                    if !expense.isEmpty{
                        cell.expenseTextField.text = expense
                        symbole = name
                    }else{
                        cell.expenseTextField.text = ""
                        cell.expenseTextField.attributedPlaceholder = NSAttributedString(string: "0.00",
                                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
                    }
                }
                cell.expenseTextField.delegate = self
                cell.expenseTextField.keyboardType = .decimalPad
                cell.selectionStyle = .none
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddExpenseWithoutDropDownCell", for: indexPath) as! AddExpenseWithoutDropDownCell
            cell.selectionStyle = .none
            return cell
        }
    }
  
  @objc func didTabAddExpenseConfirmButton(){
    let nameCellIndexPath = IndexPath(row: 0, section: 1)
    guard let nameCell: AddExpenseCategoryNameCell = addExpenseTable.cellForRow(at: nameCellIndexPath) as? AddExpenseCategoryNameCell else { return }
    
    let dropdownCelIndexPath = IndexPath(row: 1, section: 1)
    guard let dropdownCel: AddExpenseCategoryCell = addExpenseTable.cellForRow(at: dropdownCelIndexPath) as? AddExpenseCategoryCell else { return }
    
    let amountCellIndexpath = IndexPath(row: 2, section: 1)
    guard let amountCell: AddExpenseWithoutDropDownCell = addExpenseTable.cellForRow(at: amountCellIndexpath) as? AddExpenseWithoutDropDownCell else { return }
    
    if nameCell.expenseTextField.text!.isEmpty || dropdownCel.expenseTextField.text!.isEmpty || amountCell.expenseTextField.text!.isEmpty {
      
      showConfirmAlert(title: "", message: "This field cannot be left blank", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
      
    } else {
      guard let name = nameCell.expenseTextField.text else { return }
      guard let code = dropdownCel.expenseTextField.text else { return }
      guard let amount = amountCell.expenseTextField.text else { return }
      
      let amountArray = matches(for: RegExpression.shared.NumberRegex, in: amount)
      let strAmount = amountArray.joined()
      if !strAmount.isNumeric {
        showConfirmAlert(title: "warning!!", message: "Budget field should contain amount", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        return
      }
      
      var textFeildDoubleValue : Double! = Double(strAmount)
      
      var catagroyAmount = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryAmount"] as! [String]
      let categryList = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryList"] as! [String]
      
      for i in 0..<(categryList.count) where categryList[i] == categoryHeaderName {
        
        if catagroyAmount.count == 1 || catagroyAmount.isEmpty {
          UserDetails.amountArray.removeAll()
          let zeroAmount = "0"
          for _ in categryList {
            UserDetails.amountArray.append(zeroAmount)
          }
          let updatingAmountArray = ["categryList":categryList,"categryAmount": UserDetails.amountArray]
          UserDetails.creatCategoryArray.updateValue(updatingAmountArray, forKey: UserDetails.budgetID)
          UserDetails.amountArray.removeAll()
          catagroyAmount = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryAmount"] as! [String]
        }
        
        print(catagroyAmount[i])
        let doubleAmount : Double! = Double(catagroyAmount[i])
        
        if let totelAmountArrayValue = UserDetails.totalAmount[UserDetails.budgetID]{
          print(totelAmountArrayValue)
          let keys = totelAmountArrayValue.map {($0.key)}
          print(keys)
          if !keys.contains(categoryHeaderName) {
            UserDetails.totalAmount[UserDetails.budgetID]?.updateValue([], forKey: categoryHeaderName)
          }
        }
        
        guard let categoryExpenseArray = UserDetails.totalAmount[UserDetails.budgetID]?[categoryHeaderName] else { return }
        if !categoryExpenseArray.isEmpty {
          let doubleArray = categoryExpenseArray.compactMap(Double.init)
          let totelCategoryExpense = doubleArray.reduce(0, +)
          print(totelCategoryExpense)
          textFeildDoubleValue = totelCategoryExpense + textFeildDoubleValue
        }
        print(catagroyAmount[i])
        
        switch catagroyAmount[i] {
        case "0":
          let runLoop = CFRunLoopGetCurrent()
          self.showConfirmAlert(title: "Create Category Budget Alert", message: "Budget for \(self.categoryHeaderName) category is not created. Please create \(self.categoryHeaderName) category budget to add expense.", buttonTitle: "Ok", buttonStyle: .default) { [unowned self] (action) in
            UserDetails.categoryName = self.categoryHeaderName
            self.popOrPushToViewController("CreateCategoryController")
            CFRunLoopStop(runLoop)
          }
          CFRunLoopRun()
        default:
          if doubleAmount < textFeildDoubleValue{
            showConfirmAlert(title: "Adding expense which is more than category budget.", message: "This category budget has been reached.", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
          }else{
            let symbole = getSymbolForCurrencyCode(code: code)
            let timeAgo:String = DateValidation.sharedInstance.timeAgoSinceDate(Date(), currentDate: Date(), numericDates: true)
            
            if let AllValues = UserDetails.shared.dict1[UserDetails.budgetID] {
              let catagoryHeaderNameArray = AllValues["catagoryHeaderName"]
              let catagoryNameArry = AllValues["name"]
              let catagoryCodeArray = AllValues["code"]
              let catagoryAmountArray = AllValues["amount"]
              let catagoryDateArray = AllValues["currentDate"]
              
              UserDetails.categoryArr += catagoryHeaderNameArray!
              UserDetails.nameArr += catagoryNameArry!
              UserDetails.codeArr = catagoryCodeArray!
              UserDetails.amountArr += catagoryAmountArray!
              UserDetails.timeAgoArr += catagoryDateArray!
              
              UserDetails.nameArr.append(name)
              UserDetails.codeArr.append(code)
              UserDetails.amountArr.append("\(symbole) \(amount)")
              UserDetails.timeAgoArr.append(timeAgo)
              UserDetails.categoryArr.append(categoryHeaderName)
            }else{
              let totalAmount: Double! = Double(amount)
              let reminingAmount = doubleAmount - totalAmount
              let percent = (reminingAmount / totalAmount) * 100
              print(reminingAmount)
              print(percent)
              UserDetails.nameArr.append(name)
              UserDetails.codeArr.append(code)
              UserDetails.amountArr.append("\(symbole) \(amount)")
              UserDetails.timeAgoArr.append(timeAgo)
              UserDetails.categoryArr.append(categoryHeaderName)
            }
            
            let updateValues = ["catagoryHeaderName":UserDetails.categoryArr,"name":UserDetails.nameArr,"code":UserDetails.codeArr,"amount":UserDetails.amountArr,"currentDate":UserDetails.timeAgoArr]
            UserDetails.shared.dict1.updateValue(updateValues, forKey: UserDetails.budgetID)
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.dict1, storeType: "dict1")
            
            UserDetails.totalAmount[UserDetails.budgetID]?[categoryHeaderName]?.append("\(amount)")
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.totalAmount, storeType: "totalAmount")
            
            let categoryName = UserDetails.totalAmount[UserDetails.budgetID]?[categoryHeaderName]
            let doubleCategoryArray = categoryName?.compactMap(Double.init)
            let categoryExpenses = doubleCategoryArray?.reduce(0, +)
            let percent = (categoryExpenses! / doubleAmount) * 100
            let remainingAmount = doubleAmount - categoryExpenses!
            let totalSpendAmt = String(remainingAmount)
            var totalRemaining: String = ""
            let totalSpendFinalvalue = matches(for: RegExpression.shared.NumberRegex, in: totalSpendAmt)
            if (totalSpendFinalvalue[1] as? String) != nil {
                let final = totalSpendFinalvalue[1].prefix(2)
                if final == "0" || final == "00" {
                    let remaingAmount = matches(for: RegExpression.shared.NumberRegex, in: totalSpendFinalvalue[0])
                    let finalValue = remaingAmount.joined()
                    totalRemaining = finalValue.replacingOccurrences(of: ".", with: "")
                }else{
                    totalRemaining = totalSpendFinalvalue[0] + final
                }
            }
            var Symbol = getSymbolForCurrencyCode(code: code)
            for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == code{
              Symbol = valueArray[i]
            }
            
            if percent >= 95 {
              NotificationController.shared.registerLocalNotification()
              
              NotificationController.shared.scheduleNotification(notificatioTitle: "Expense Alert", notificationMessage: "You have \(Symbol)\(totalRemaining) remaining in your \(categoryHeaderName) budget",identifier: "Expense Alert")
              
              let currentDate = Date()
              let formatter = DateFormatter()
              formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
              let date = formatter.string(from: currentDate)
              if UserDetails.shared.notificationArray.isEmpty {
                
                var array = [String]()
                let title = "Expense Alert"
                let updateValue = "You have \(Symbol)\(remainingAmount) remaining in your \(categoryHeaderName) budget"
                let updateValue1 = date
                
                array.append(title)
                array.append(updateValue)
                array.append(updateValue1)
                
                UserDetails.shared.notificationArray.append(array)
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.notificationArray, storeType: "notificationArray")
                //              UIApplication.shared.applicationIconBadgeNumber = UserDetails.shared.notificationArray.count
              }else{
                var array = [String]()
                let title = "Expense Alert"
                let updateValue = "You have \(Symbol)\(remainingAmount) remaining in your \(categoryHeaderName) budget"
                let updateValue1 = date
                
                array.append(title)
                array.append(updateValue)
                array.append(updateValue1)
                
                UserDetails.shared.notificationArray.append(array)
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.notificationArray, storeType: "notificationArray")
                //              UIApplication.shared.applicationIconBadgeNumber = UserDetails.shared.notificationArray.count
              }
              
            }
            
            let tripBudgetAmountGet = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as! String
            let number = matches(for: RegExpression.shared.NumberRegex, in: tripBudgetAmountGet)
            let Code = matches(for: RegExpression.shared.CodesRegex, in: tripBudgetAmountGet)
            var symbol = getSymbolForCurrencyCode(code: Code.joined())
            for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == Code.joined(){
              symbol = valueArray[j]
            }
            
            if UserDetails.totalExpenseAddition.count != 0 {
              if let _ = UserDetails.totalExpenseAddition[UserDetails.budgetID]{
                var valueUpdated = UserDetails.totalExpenseAddition[UserDetails.budgetID]
                valueUpdated?.append(Double(strAmount)!)
                
                let Expense = valueUpdated?.reduce(0, +)
                
                let stringValue = number.joined()
                let doubleValue : Double! = Double(stringValue)
                let amount = "\(doubleValue - Expense!) \(Code.joined())"
                
                let finalvalue = matches(for: RegExpression.shared.NumberRegex, in: amount)
                print(finalvalue)
                let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
                
                notificationReminingAmount = "\(symbol) \(final)"
                
                UserDetails.totalExpenseAddition.updateValue(valueUpdated!, forKey: UserDetails.budgetID)
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.totalExpenseAddition, storeType: "totalExpenseAddition")
                print(UserDetails.totalExpenseAddition)
              }else{
                
                let stringValue = number.joined()
                let doubleValue : Double! = Double(stringValue)
                let amount = "\(doubleValue - Double(strAmount)!) \(Code.joined())"
                
                let finalvalue = matches(for: RegExpression.shared.NumberRegex, in: amount)
                print(finalvalue)
                let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
                
                notificationReminingAmount = "\(final)"
//                notificationReminingAmount = "\(symbol) \(strAmount)"
                let UpdatingTheValues = [Double(strAmount)!]
                UserDetails.totalExpenseAddition.updateValue(UpdatingTheValues, forKey: UserDetails.budgetID)
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.totalExpenseAddition, storeType: "totalExpenseAddition")
                print(UserDetails.totalExpenseAddition)
              }
            }else{
                let stringValue = number.joined()
                let doubleValue : Double! = Double(stringValue)
                let expense: Double! = Double(strAmount)
                let amount = "\(symbol) \(doubleValue - expense)"
                notificationReminingAmount = amount
                let UpdatingTheValues = [Double(strAmount)!]
                UserDetails.totalExpenseAddition.updateValue(UpdatingTheValues, forKey: UserDetails.budgetID)
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.totalExpenseAddition, storeType: "totalExpenseAddition")
                print(UserDetails.totalExpenseAddition)
            }
            
            UserDetails.nameArr.removeAll()
            UserDetails.codeArr.removeAll()
            UserDetails.amountArr.removeAll()
            UserDetails.timeAgoArr.removeAll()
            UserDetails.categoryArr.removeAll()
            
            let totelBudgetAmount = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as! String
            let all = matches(for: RegExpression.shared.NumberRegex, in: totelBudgetAmount)
            if let amt = Float(all.joined()) {
              guard let amount = UserDetails.totalExpenseAddition[UserDetails.budgetID] else { return }
              let totelExpense = amount.reduce(0, +)
              let totalSpendAmount = amt - Float(totelExpense)
              let reminAmount = (totalSpendAmount / amt) * 100
              
              let currentDate = Date()
              let formatter = DateFormatter()
              formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
              let date = formatter.string(from: currentDate)
              
              let tripName = UserDetails.shared.tripArray[UserDetails.budgetID]?["tripName"] as! String
              
              for i in 0..<(symboleGetArray.count) where symboleGetArray[i] == code{
                Symbol = valueArray[i]
              }
              
              if reminAmount <= 5.0{
                NotificationController.shared.registerLocalNotification()
                NotificationController.shared.scheduleNotification(notificatioTitle: "Budget Alert", notificationMessage: "You have \(notificationReminingAmount) remaining in your \(tripName) budget",identifier: "Budget Alert")
                if UserDetails.shared.notificationArray.isEmpty {
                  
                  var array = [String]()
                  let title = "Budget Alert"
                  let updateValue = "You have \(notificationReminingAmount) remaining in your \(tripName) budget"
                  let updateValue1 = date
                  
                  array.append(title)
                  array.append(updateValue)
                  array.append(updateValue1)
                  
                  UserDetails.shared.notificationArray.append(array)
                  StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.notificationArray, storeType: "notificationArray")
                  //                UIApplication.shared.applicationIconBadgeNumber = UserDetails.shared.notificationArray.count
                }else {
                  var array = [String]()
                  let title = "Budget Alert"
                  let updateValue = "You have \(notificationReminingAmount) remaining in your \(tripName) budget"
                  let updateValue1 = date
                  
                  array.append(title)
                  array.append(updateValue)
                  array.append(updateValue1)
                  
                  UserDetails.shared.notificationArray.append(array)
                  StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.notificationArray, storeType: "notificationArray")
//                  UIApplication.shared.applicationIconBadgeNumber = UserDetails.shared.notificationArray.count
                }
              }
            }
          }
          
          let categoryBool = UserDetails.colorArrayRandomPicker[UserDetails.budgetID]?.contains(where: { (key, value) -> Bool in
            key == categoryHeaderName
          })
          
          if let categoryBool = categoryBool {
            if !categoryBool {
              var colorCount : Int! = UserDetails.colorIdForTrip[UserDetails.budgetID] as? Int
              
              if colorCount == 5 {
                colorCount = 0
                UserDetails.colorIdForTrip.updateValue(colorCount, forKey: UserDetails.budgetID)
              }
              let colorArrayValue = UserDetails.colorDataArray[colorCount]
              colorCount += 1
              UserDetails.colorIdForTrip.updateValue(colorCount, forKey: UserDetails.budgetID)
              StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.colorIdForTrip, storeType: "colorIdForTrip")
              
              UserDetails.colorArrayRandomPicker[UserDetails.budgetID]?.updateValue(colorArrayValue, forKey: categoryHeaderName)
              StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.colorArrayRandomPicker, storeType: "colorArrayRandomPicker")
            }
          }
//          let randomColor = Int(arc4random() % UInt32(UserDetails.colorDataArray.count))
//          let colorArrayValue = UserDetails.colorDataArray[randomColor]
//
//          UserDetails.colorArrayRandomPicker[UserDetails.budgetID]?.updateValue(colorArrayValue, forKey: categoryHeaderName)
//
//          StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.colorArrayRandomPicker, storeType: "colorArrayRandomPicker")
          if UserDetails.AddToWallet.WalletClicked == false {
            UserDetails.AddToWallet.WalletClicked = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.newWindow(title: "Create Expense", message: "Expense Added to \(categoryHeaderName)", buttonTitle: "Ok", controller: self)
          }else{
            self.navigationController?.popViewController(animated: true)
          }
        }
      }
    }
  }
  
  func didTapButtonDismiss() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.removeAllViews()
    self.navigationController?.popViewController(animated: true)
  }
    
    @objc func selectCurrencyTapped(){
        UserDetails.SelectExpenseCurrencyBool.AddExpenseClicked = false
        presentDissmiss(controller: "CountryViewController")
    }
}

extension AddExpenseController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 65.0
        }else {
            return 65.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let contentView = UIView(frame: CGRect(x: 5, y: 10, width: tableView.frame.size.width - 5, height: 40.0))
            contentView.clipsToBounds = true
            contentView.layer.masksToBounds = false
            contentView.layer.shadowColor = UIColor(red: 0.85, green: 0.89, blue: 0.91, alpha: 0.50).cgColor
            contentView.layer.shadowOpacity = 0.5
            contentView.layer.shadowRadius = 2
            contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
            contentView.layer.cornerRadius = 6
            contentView.layer.borderColor = UIColor(red: 0.86, green: 0.87, blue: 0.89, alpha: 0.30).cgColor
            contentView.layer.borderWidth = 1
            contentView.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)
            contentView.alpha = 1
            
            let label = UILabel(frame: CGRect(x: 35.0, y: 0.0, width: contentView.frame.size.width - 30, height: 60.0))
            label.text = categoryHeaderName
            label.font = UIFont(name: "Montserrat-Medium", size: 16)
            label.textColor = UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)
            contentView.addSubview(label)
            
            let dropDown : UIButton = UIButton(frame: CGRect(x: contentView.frame.size.width - 30, y: 23, width: 15.0, height: 9.0))
            dropDown.setImage(UIImage(named: "Drop_Down"), for: .normal)
            sectionValue = dropDown.tag
            contentView.addSubview(dropDown)
            
            contentView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
            contentView.addGestureRecognizer(tap)
            
            return contentView
        }else {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 5.0
            button.setTitle("Add Category", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1)
            button.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 16)
            button.addTarget(self, action: #selector(didTapAddCategory), for: .touchUpInside)
            
            return button
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            categoryHeaderName = (walletExpands?.names[indexPath.row])!
            //      categoryHeaderName = addexpensive.categoryArray[indexPath.section].names[indexPath.row]
            handleExpandClose()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
                self.addExpenseTable.reloadData()
            })
        }
    }
}

extension AddExpenseController{
    
    @objc func handleExpandClose() {
        
        let section = 0
        var indexPaths = [IndexPath]()
        
        for row in (walletExpands?.names.indices)! {
            
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isExpanded = walletExpands?.isExpanded
        walletExpands?.isExpanded = !isExpanded!
        
        if isExpanded! {
            addExpenseTable.deleteRows(at: indexPaths, with: .fade)
        } else {
            addExpenseTable.insertRows(at: indexPaths, with: .fade)
        }
    }
  
  @objc func didTapAddCategory(){
    let CategoryAmountArray = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryAmount"] as! [String]
    let totalBudget     = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as! String
    let doubleArrayn = CategoryAmountArray.compactMap(Double.init)
    let totelBudgetAmount = doubleArrayn.reduce(0, +)
    let budgetAmount  = matches(for: RegExpression.shared.NumberRegex, in: totalBudget)
    let stringVar     = budgetAmount.joined()
    let tripTotalBudget: Double! = Double(stringVar)
    if tripTotalBudget > totelBudgetAmount{
      dimView.isHidden = false
      cancelButton.isHidden = false
      categoryNameTextBox.text = ""
      categoryBudgetText.text = ""
      setView(view: popUpView, hidden: false)
    }else{
      showConfirmAlert(title: "Trip Budget Exceeded", message: "This category budget would exceed the main trip budget. Please reduce and try again or increase your trip budget.", buttonTitle: "Dismiss", buttonStyle: .default, confirmAction: nil)
    }
  }
    
    @objc func didTabPopUpConfirmButton(){
        if (!(categoryNameTextBox.text?.isEmpty)! && !(categoryBudgetText.text?.isEmpty)!){
            dimView.isHidden = true
            cancelButton.isHidden = true
            if let categoryName = categoryNameTextBox.text,  let categoryBudget = categoryBudgetText.text{
              var categA = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryAmount"] as! [String]
              var categL = UserDetails.creatCategoryArray[UserDetails.budgetID]?["categryList"] as! [String]
              
              var doubles = categA.compactMap(Double.init)
              let amount = matches(for: RegExpression.shared.NumberRegex, in: categoryBudget)
              doubles.append(Double(amount.joined()) as! Double)
              let sum = doubles.reduce(0, +)
              let totelBudget : String! = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as? String
              let totelBudgetAmount = matches(for: RegExpression.shared.NumberRegex, in: totelBudget)
              let doubleValue : Double! = Double(totelBudgetAmount.joined())
              if sum > doubleValue {
                showConfirmAlert(title: "Exceed Category Budget", message: "Your category budget exceeds the main trip budget", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
              }else{
                walletExpands?.names.append(categoryName)
                categA.append(categoryBudget)
                categL.append(categoryName)
                UserDetails.categoryWholeArray[UserDetails.budgetID]!.names.append(categoryName)
                let updateValues = ["categryList":categL,"categryAmount":categA]
                UserDetails.creatCategoryArray.updateValue(updateValues, forKey: UserDetails.budgetID)
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.creatCategoryArray, storeType: "creatCategoryArray")
                StrongBoxController.sharedInstance.storeExpandableArray(array: UserDetails.categoryWholeArray, storeType: "categoryWholeArray")
                addExpenseTable.reloadData()
              }
            }
            setView(view: popUpView, hidden: true)
        }else{
            showConfirmAlert(title: "", message: "Field cannot be Blank", buttonTitle: "Dismiss", buttonStyle: .default, confirmAction: nil)
            dimView.isHidden = false
            cancelButton.isHidden = false
            setView(view: popUpView, hidden: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryNameTextBox.resignFirstResponder()
        categoryBudgetText.resignFirstResponder()
        
        if (!(categoryNameTextBox.text?.isEmpty)! && !(categoryBudgetText.text?.isEmpty)!){
            popUpconfirmButton.isUserInteractionEnabled = true
            return true
        }else{
            popUpconfirmButton.isUserInteractionEnabled = false
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .decimalPad{
          
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
          // let isNumeric = newText.isEmpty || (Double(newText) != nil)
          let numberOfDots = newText.components(separatedBy: ".").count - 1
          
          let numberOfDecimalDigits: Int
          if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
          } else {
            numberOfDecimalDigits = 0
          }
          
          return numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }else{
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let TotalBudgetCellIndexPath = IndexPath(row: 2, section: 1)
        guard let totelCell: AddExpenseWithoutDropDownCell = addExpenseTable.cellForRow(at: TotalBudgetCellIndexPath) as? AddExpenseWithoutDropDownCell else { return }
        if textField == totelCell.expenseTextField {
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
            let myheight = addExpenseTable.frame.height
            // Get the top Y point where the keyboard will finish on the view
            let keyboardEndPoint = myheight - keyboardFrame.height
            // Get the the bottom Y point of the textInput and transform it to the currentView coordinates.
            guard let inputTextFeild = inputActive else { return }
            if let pointInTable = inputTextFeild.superview?.convert(inputTextFeild.frame.origin, to: addExpenseTable) {
                let textFieldBottomPoint = (pointInTable.y + inputTextFeild.frame.size.height -  100)
                // Finally check if the keyboard will cover the textInput
                if keyboardEndPoint <= textFieldBottomPoint {
                    addExpenseTable.contentOffset.y = textFieldBottomPoint - keyboardEndPoint
                } else {
                    addExpenseTable.contentOffset.y = 0
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        addExpenseTable.contentOffset.y = 0
    }
}

