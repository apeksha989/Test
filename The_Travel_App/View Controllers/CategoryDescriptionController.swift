//
//  CategoryDescriptionController.swift
//  Haggle
//
//  Created by Anil Kumar on 19/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class CategoryDescriptionController: UIViewController {
  
  private let categoryView = UIViewFactory()
  .build()
  
  private let categoryTitle = UILabelFactory(text: "")
  .build()
  
  private let categoryBackButton = UIButtonFactory(title: "")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
  .build()
  
  private let categoryEditButton = UIButtonFactory(title: "")
    .addTarget(self, action: #selector(editClicked), for: .touchUpInside)
  .build()
  
  private let remainingBudgetAmount = UILabelFactory(text: "420.50 EUR".uppercased())
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-Bold", size: 40)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  private let BGIcon = UIImageFactory()
    .backgroundColor(color: .clear)
    .setImage(imageString: "Background_Icons")
  .build()
  
  private let totalSpendAmount = UILabelFactory(text: "")
    .textFonts(with: UIFont(name: "Montserrat-Bold", size: 26)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  private let totalSpendLabel = UILabelFactory(text: "Total Budget")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 12)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  private lazy var transactionTable : UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  let remainingBudgetLabel = UILabelFactory(text: "Remaining budget")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 12)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  var listExpenses = [(name:String,date:String,amount:String)]()
  let valueArray = RegExpression.shared.codeToSymbole.map {($0.value)}
  let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}

  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------CategoryDescriptionController------------>😀")
    transactionTable.delegate = self
    transactionTable.dataSource = self
    transactionTable.separatorStyle = .none
    transactionTable.tableFooterView = UIView()
    transactionTable.allowsSelection = false
    setUpCellRegistration()
    setUpLayoutViews()
    
    totalSpendAmount.isUserInteractionEnabled = false
    guard let cateName = UserDetails.shared.dict1[UserDetails.budgetID]?["catagoryHeaderName"] else {
      totalSpendAmount.text = UserDetails.totelBudget
      remainingBudgetAmount.text = UserDetails.totelBudget
      return
    }
    for i in 0..<(cateName.count) {
      if UserDetails.categoryName == UserDetails.shared.dict1[UserDetails.budgetID]?["catagoryHeaderName"]?[i]{
        listExpenses.append((name: (UserDetails.shared.dict1[UserDetails.budgetID]?["name"]?[i])!, date: (UserDetails.shared.dict1[UserDetails.budgetID]?["currentDate"]?[i])!, amount: "- \(UserDetails.shared.dict1[UserDetails.budgetID]!["amount"]![i])"))
      }
    }
    
    print(UserDetails.categoryName)
    print(UserDetails.totelBudget)
    
    
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        UserDetails.tot = 0
        let symbole = UserDetails.shared.tripArray[UserDetails.budgetID]?["code"] as? String
        var tripSymbol = getSymbolForCurrencyCode(code: symbole!)
        for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == symbole{
            tripSymbol = valueArray[j]
        }
        UserDetails.reminingBudgetAmountConstant = "\(tripSymbol) \(UserDetails.totelBudget)"
        
        UserDetails.totelBudget = UserDetails.reminingBudgetAmountConstant
        
        guard let cateName = UserDetails.shared.dict1[UserDetails.budgetID]?["catagoryHeaderName"] else {
            totalSpendAmount.text = UserDetails.totelBudget
            remainingBudgetAmount.text = UserDetails.totelBudget
            return
        }
        
        UserDetails.reminingBudgetAmountConstant = UserDetails.totelBudget
        totalSpendAmount.text = UserDetails.totelBudget
        remainingBudgetAmount.text = UserDetails.totelBudget
        
        for i in 0..<(cateName.count) {
            
            if UserDetails.categoryName == UserDetails.shared.dict1[UserDetails.budgetID]?["catagoryHeaderName"]?[i]{
                let finalAmount = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.totelBudget)
                
                let bud = UserDetails.shared.dict1[UserDetails.budgetID]?["amount"]?[i]
                
                let finaAmountDict = matches(for: RegExpression.shared.NumberRegex, in: bud!)
                
                let strValue = finaAmountDict.joined()
                let resultValueDouble = Double(strValue)
                UserDetails.tot = UserDetails.tot + resultValueDouble!
                
                guard let num1 = Double(finalAmount.joined()) else {return}
                let num2 : Double = UserDetails.tot
                let tripCode = UserDetails.shared.tripArray[UserDetails.budgetID]?["code"] as! String
                var tripSymbol = getSymbolForCurrencyCode(code: tripCode)
                for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == tripCode{
                    tripSymbol = valueArray[j]
                }
                let totalSpendAmt = String(num1)
                var totalSpend: String = ""
                let totalSpendFinalvalue = matches(for: RegExpression.shared.NumberRegex, in: totalSpendAmt)
                if (totalSpendFinalvalue[1] as? String) != nil {
                    let final = totalSpendFinalvalue[1].prefix(2)
                    if final == "0" || final == "00" {
                        let remaingAmount = matches(for: RegExpression.shared.NumberRegex, in: totalSpendFinalvalue[0])
                        let finalValue = remaingAmount.joined()
                        totalSpend = finalValue.replacingOccurrences(of: ".", with: "")
                    }else{
                        totalSpend = totalSpendFinalvalue[0] + final
                    }
                }
                UserDetails.reminingBudgetAmountConstant = "\(num1 - num2)"
                totalSpendAmount.text = "\(tripSymbol) \(totalSpend)"
                let doublAmount: Double = num1 - num2
                let finalvalue = matches(for: RegExpression.shared.NumberRegex, in: String(doublAmount))
                var remaingBudget: String = ""
                print(finalvalue)
                if (finalvalue[1] as? String) != nil {
                    let final = finalvalue[1].prefix(2)
                    if final == "0" || final == "00" {
                        let remaingAmount = matches(for: RegExpression.shared.NumberRegex, in: finalvalue[0])
                        let finalValue = remaingAmount.joined()
                        remaingBudget = finalValue.replacingOccurrences(of: ".", with: "")
                    }else{
                        remaingBudget = finalvalue[0] + final
                    }
                }
                remainingBudgetAmount.text = "\(tripSymbol) \(remaingBudget)"
                transactionTable.reloadData()
            }
        }
    }
    
  @objc func editClicked(){
    popOrPushToViewController("CreateCategoryController")  
  }
    
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    gradiantView(categoryView, self)
    
    categoryTitle.text = UserDetails.categoryName
    categoryTitle.textAlignment = NSTextAlignment.center
    categoryTitle.font = UIFont(name: "Montserrat-SemiBold", size: 19)
    categoryTitle.textColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)
    
    categoryBackButton.setImage(UIImage(named: "BackBtn"), for: .normal)
    
    categoryEditButton.setTitle("Edit", for: .normal)
    categoryEditButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
    categoryEditButton.setTitleColor(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1), for: .normal)
  }
  
  func setUpCellRegistration(){
    transactionTable.register(TransactionsViewCell.self, forCellReuseIdentifier: "TransactionsViewCell")
  }
  
  @objc func backButtonTapped(){    
    navigationController?.popViewController(animated: true)
  }
  
  func setUpLayoutViews(){
    
    view.addSubview(categoryView)
    categoryView.addSubview(categoryTitle)
    categoryView.addSubview(categoryBackButton)
    categoryView.addSubview(categoryEditButton)
    categoryView.addSubview(remainingBudgetAmount)
    categoryView.addSubview(BGIcon)
    BGIcon.addSubview(remainingBudgetLabel)
    view.addSubview(totalSpendAmount)
    BGIcon.addSubview(totalSpendLabel)
    
    view.addSubview(transactionTable)
    
    categoryView.bringSubviewToFront(categoryTitle)
    categoryView.bringSubviewToFront(categoryBackButton)
    categoryView.bringSubviewToFront(categoryEditButton)
    categoryView.bringSubviewToFront(remainingBudgetAmount)
    categoryView.bringSubviewToFront(BGIcon)
    BGIcon.bringSubviewToFront(remainingBudgetLabel)
    BGIcon.bringSubviewToFront(totalSpendAmount)
    BGIcon.bringSubviewToFront(totalSpendLabel)
    view.bringSubviewToFront(transactionTable)
    view.bringSubviewToFront(totalSpendAmount)
    setUpConstraintsToAttributes()
  }
  
  func setUpConstraintsToAttributes(){
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      categoryView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/2.47 + 20.0, enableInsets: true)
      
      categoryTitle.layoutAnchor(top: categoryView.topAnchor, left: nil, bottom: nil, right: nil, centerX: categoryView.centerXAnchor, centerY: nil, paddingTop: 54.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
    default:
      categoryView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/2.47, enableInsets: true)
      
      categoryTitle.layoutAnchor(top: categoryView.topAnchor, left: nil, bottom: nil, right: nil, centerX: categoryView.centerXAnchor, centerY: nil, paddingTop: 34.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
    }
    categoryBackButton.layoutAnchor(top: nil, left: categoryView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: categoryTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 60.0, height: 60.0, enableInsets: true)
    
    categoryEditButton.layoutAnchor(top: nil, left: nil, bottom: nil, right: categoryView.rightAnchor, centerX: nil, centerY: categoryTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 15.0, width: 35, height: 21.0, enableInsets: true)
    
    remainingBudgetAmount.layoutAnchor(top: nil, left: categoryView.leftAnchor, bottom: BGIcon.topAnchor, right: categoryView.rightAnchor, centerX: categoryView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 20.0, paddingBottom: 0.0, paddingRight: 20.0, width: 0.0, height: 52.0, enableInsets: true)
    
    BGIcon.layoutAnchor(top: nil, left: categoryView.leftAnchor, bottom: categoryView.bottomAnchor, right: categoryView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 23.0, paddingBottom: 6.0, paddingRight: 15.0, width: 0.0, height: categoryView.frame.size.height/2.07, enableInsets: true)
    
    remainingBudgetLabel.layoutAnchor(top: BGIcon.topAnchor, left: BGIcon.leftAnchor, bottom: nil, right: nil, centerX: categoryView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 97.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 18.0, enableInsets: true)
    
//    remainingBudgetLabel.layoutAnchor(top: BGIcon.topAnchor, left: BGIcon.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 97.0, paddingBottom: 0.0, paddingRight: 0.0, width: 120.0, height: 18.0, enableInsets: true)
    
    totalSpendAmount.layoutAnchor(top: nil, left: BGIcon.leftAnchor, bottom: BGIcon.bottomAnchor, right: BGIcon.rightAnchor, centerX: BGIcon.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 50.0, paddingBottom: 20.0, paddingRight: 50.0, width: 0.0, height: 35, enableInsets: true)
    
    totalSpendLabel.layoutAnchor(top: nil, left: BGIcon.leftAnchor, bottom: totalSpendAmount.topAnchor, right: nil, centerX: categoryView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 107.0, paddingBottom: 0.0, paddingRight: 0.0, width: 73.0, height: 17.0, enableInsets: true)
    
//    totalSpendLabel.layoutAnchor(top: nil, left: BGIcon.leftAnchor, bottom: totalSpendAmount.topAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 107.0, paddingBottom: 0.0, paddingRight: 0.0, width: 73.0, height: 17.0, enableInsets: true)
    
    transactionTable.layoutAnchor(top: categoryView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 25.0, paddingLeft: 10.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
  }
}

extension CategoryDescriptionController: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 25
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if listExpenses.isEmpty {
        return nil
    }else{
      return "Transactions"
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    headerLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
    headerLabel.textColor = UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1)
    headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    headerLabel.sizeToFit()
    view.addSubview(headerLabel)
    view.backgroundColor = UIColor.white
    return view
  }
}

extension CategoryDescriptionController: UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if listExpenses.isEmpty {
       tableView.setEmptyMessage("No Transactions")
        return 0
    }else{
      tableView.setEmptyMessage("")
      return listExpenses.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsViewCell", for: indexPath) as! TransactionsViewCell
    let indexValue = listExpenses[safe: indexPath.row]
    if indexValue != nil {
      cell.transactionName.text = indexValue?.name
      cell.transactionAmount.text = indexValue?.amount
      cell.expirydays.text = indexValue?.date
    }
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}


