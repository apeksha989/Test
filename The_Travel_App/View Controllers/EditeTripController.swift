//
//  EditeTripController.swift
//  Haggle
//
//  Created by Anil Kumar on 10/05/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

var doneClicked = false

class EditeTripController: UIViewController {
    
    private let editeTripTitle     = UILabelFactory(text: "Edit Trip")
        .textAlignment(with: .center)
        .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
        .build()
    
    private let EditTripBackButton = UIButtonFactory(title: "", style: .normal)
        .setBackgroundImage(image: "Black_Back_Btn")
        .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        .build()
    
    private let confirmButton     = UIButtonFactory(title: "Update")
        .setTitileColour(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
        .addTarget(self, action:  #selector(confirmButtonTapped), for: .touchUpInside)
        .build()
    
    private let errorMessage      = UILabelFactory(text: "You have entered an incorrect values")
        .textAlignment(with: .center)
        .textColor(with: hexStringToUIColor(hex: "#00D2FF"))
        .textFonts(with: UIFont(name: "OpenSans-Regular", size: 9.0)!)
        .build()
    
    private let editeTripNavigationView = UIViewFactory()
        .build()
    
    private lazy var editeTipeMenu : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    let valueArray = RegExpression.shared.codeToSymbole.map {($0.value)}
    let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
    
    lazy var dates                     = String()
    lazy var firstDate                 = String()
    lazy var year                      = String()
    lazy var startDateValue            = Date()
    lazy var endDateValue              = Date()
    lazy var currencyCode              = String()
    lazy var budget                    = String()
    lazy var Tripname                  = String()
    lazy var iconName                  = String()
    lazy var countryName               = String()
    lazy var symbole                   = String()
    var iconUpdateFlag                 = false
    var inputActive : UITextField?
    var countryIcon = String()
    var currentDate = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("<---------EditeTripController------------>😀")
        countryIcon =  UserDetails.shared.tripArray[UserDetails.budgetID]?["countryIcon"] as! String
        countryName =  UserDetails.shared.tripArray[UserDetails.budgetID]?["countryName"] as! String
        currencyCode = UserDetails.shared.tripArray[UserDetails.budgetID]?["code"] as! String
        budget = UserDetails.shared.tripArray[UserDetails.budgetID]?["totelBudjet"] as! String
        Tripname = UserDetails.shared.tripArray[UserDetails.budgetID]?["tripName"] as! String
        startDateValue = UserDetails.shared.tripArray[UserDetails.budgetID]?["startData"] as! Date
        endDateValue = UserDetails.shared.tripArray[UserDetails.budgetID]?["endDate"] as! Date
        year = UserDetails.shared.tripArray[UserDetails.budgetID]?["year"] as! String
        
        dates = dateformate(format: "d/MM/yy", date: startDateValue) + " - " +  dateformate(format: "d/MM/yy", date: endDateValue)
        
        errorMessage.isHidden = true
        let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        tapOnScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnScreen)
        
        editeTipeMenu.dataSource = self
        editeTipeMenu.delegate = self
        editeTipeMenu.separatorStyle = .none
        editeTipeMenu.tableFooterView = UIView()
        editeTipeMenu.isScrollEnabled = false
        
        setUpCellRegistration()
        setUpLayoutViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradiantViewButton(confirmButton)
    }
    
    @objc func backButtonTapped(){
        removeData()
        navigationController?.popViewController(animated: true)
    }
    @objc func confirmButtonTapped(){
        
        confirmButton.loadingIndicator(show: true)
        confirmButton.setTitle("", for: .normal)
        if Reachability.isConnectedToNetwork() {
            
            let checkValidation = validationTextFeilds()
            if checkValidation{
                UserDetails.previousDateSelected = true
                self.confirmButton.loadingIndicator(show: false)
                self.confirmButton.setTitle("Update", for: .normal)
                errorMessage.isHidden = true
                popOrPushToViewController("BudgetInformationController")
            }else{
                
                self.confirmButton.loadingIndicator(show: false)
                self.confirmButton.setTitle("Update", for: .normal)
                
                UIView.animate(withDuration: 1) { [weak self] in
                    self?.errorMessage.isHidden = false
                }
            }
        }else{
            confirmButton.loadingIndicator(show: false)
            confirmButton.setTitle("Update", for: .normal)
            showConfirmAlert(title: "", message: "Sorry, we can't connect right now. Please check your internet connection and try again.", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }
        
    }
    
    func validationTextFeilds()-> Bool{
        
        let AddNameCellIndexPath = IndexPath(row: 0, section: 0)
        let addcell: editeAddNameCell = editeTipeMenu.cellForRow(at: AddNameCellIndexPath) as! editeAddNameCell
        
        let ChooseCurrencyCellIndexPath = IndexPath(row: 2, section: 0)
        let chooseCell: EditeChooseCurrencyCell = editeTipeMenu.cellForRow(at: ChooseCurrencyCellIndexPath) as! EditeChooseCurrencyCell
        
        let TotalBudgetCellIndexPath = IndexPath(row: 3, section: 0)
        let totelCell: EditeTotelBudgetCell = editeTipeMenu.cellForRow(at: TotalBudgetCellIndexPath) as! EditeTotelBudgetCell
        
        let addCellCount = addcell.tripName.text?.count
        let totelCellCount = totelCell.totalBudget.text?.count
        
        if addCellCount == 0 {
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
            firstDate = dateformate(format: "MMM dd", date: startDateValue) + " - " +  dateformate(format: "MMM dd", date: endDateValue)
            UserDetails.getAddtripeAttibutes.value = getNumber.joined()
            //      countryIcon = UserDetails.shared.tripArray[UserDetails.budgetID]?["countryIcon"] as! String
            let totelBudjet : String! = getNumber.joined() + " " + currencyCode
            let countryname : String! = chooseCell.countryName.text
            let getBg = UserDetails.shared.tripArray[UserDetails.budgetID]?["backgroundImage"] as! String
            //      let ids = UserDetails.shared.tripArray.map{ ($0.key) }
            //      for index in 0..<(ids.count) where UserDetails.budgetID == index {
            let updateValue = ["tripName":tripName!,"date":firstDate,"year":year,"startData":startDateValue,"endDate":endDateValue,"countryName":countryname!,"totelBudjet":totelBudjet!,"backgroundImage":getBg,"code":currencyCode,"countryIcon":countryIcon] as [String : Any]
            UserDetails.shared.tripArray.updateValue(updateValue, forKey: UserDetails.budgetID)
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.shared.tripArray, storeType: "tripArrayStore")
          
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
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.getAddtripeAttibutes.value, storeType: "getAddtripeAttibutes.value")
            
            return true
        }
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
                self.EditTripBackButton.isUserInteractionEnabled = true
                self.confirmButton.isUserInteractionEnabled = true
                self.confirmButton.loadingIndicator(show: false)
                self.confirmButton.setTitle("Update", for: .normal)
                self.showConfirmAlert(title: "", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: { (action) in
                })
            }
        }
    }
    
    @objc func resignKeyboard(){
        self.view.endEditing(true)
    }
    
    func dateformate(format: String, date: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return  dateFormatter.string(from: date)
    }
    
    func setUpCellRegistration(){
        editeTipeMenu.register(editeAddNameCell.self, forCellReuseIdentifier: "AddNameCell")
        editeTipeMenu.register(EditeDateCell.self, forCellReuseIdentifier: "SelectDatesCell")
        editeTipeMenu.register(EditeChooseCurrencyCell.self, forCellReuseIdentifier: "ChooseCurrencyCell")
        editeTipeMenu.register(EditeTotelBudgetCell.self, forCellReuseIdentifier: "TotalBudgetCell")
    }
    
    func setUpLayoutViews(){
        editeTipeMenu.tableFooterView?.addSubview(errorMessage)
        editeTipeMenu.tableFooterView?.bringSubviewToFront(errorMessage)
        view.addSubview(editeTripNavigationView)
        editeTripNavigationView.addSubview(editeTripTitle)
        editeTripNavigationView.addSubview(EditTripBackButton)
        view.addSubview(editeTipeMenu)
        view.addSubview(confirmButton)
        
        editeTripNavigationView.bringSubviewToFront(editeTripTitle)
        editeTripNavigationView.bringSubviewToFront(EditTripBackButton)
        view.bringSubviewToFront(editeTipeMenu)
        view.bringSubviewToFront(confirmButton)
        
        setUpConstraintsToAttributes()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if doneClicked == false{
            countryCode(name: UserDetails.getAddtripeAttibutes.name, icon: UserDetails.getAddtripeAttibutes.icon, symbole: UserDetails.getAddtripeAttibutes.code)
        }
        editeTipeMenu.reloadData()
    }
    
    
    func countryCode(name: String, icon: String, symbole: String) {
        let indexPath = IndexPath.init(row: 2, section: 0)
        guard let cell = editeTipeMenu.cellForRow(at: indexPath) as? EditeChooseCurrencyCell else { return }
        if !name.isEmpty,!icon.isEmpty{
            countryIcon = icon
            countryName = name
            currencyCode = symbole
            cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height / 2
            cell.iconImage.layer.masksToBounds = true
            cell.countryName.isHidden = false
            cell.iconImage.isHidden = false
            cell.countryName.text = name
            self.countryName = name
            iconUpdateFlag = true
            iconName = icon
            self.symbole = symbole
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
    
    func removeData(){
        let AddNameCellIndexPath = IndexPath(row: 0, section: 0)
        guard let addcell: editeAddNameCell = editeTipeMenu.cellForRow(at: AddNameCellIndexPath) as? editeAddNameCell else { return }
        
        let SelectDatesCellIndexPath = IndexPath(row: 1, section: 0)
        guard let selectDates: EditeDateCell = editeTipeMenu.cellForRow(at: SelectDatesCellIndexPath) as? EditeDateCell else { return }
        
        let ChooseCurrencyCellIndexPath = IndexPath(row: 2, section: 0)
        guard let chooseCell: EditeChooseCurrencyCell = editeTipeMenu.cellForRow(at: ChooseCurrencyCellIndexPath) as? EditeChooseCurrencyCell else { return }
        
        let TotalBudgetCellIndexPath = IndexPath(row: 3, section: 0)
        guard let totelCell: EditeTotelBudgetCell = editeTipeMenu.cellForRow(at: TotalBudgetCellIndexPath) as? EditeTotelBudgetCell else { return }
        
        addcell.tripName.text = ""
        selectDates.tripDates.attributedText = NSAttributedString(string: "Trip Dates",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
        dates = ""
        UserDetails.getAddtripeAttibutes.name = ""
        UserDetails.getAddtripeAttibutes.icon = ""
        chooseCell.countryName.isHidden = true
        chooseCell.iconImage.isHidden = true
        totelCell.totalBudget.text = ""
    }
}

extension EditeTripController : CalendarDateRangePickerViewControllerDelegate{
    func didCancelPickingDateRange() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func dropDownTapped(){
        if UserDetails.previousDateSelected == false {
            let calendar = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
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
            let calendar = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
            calendar.delegate = self
            calendar.minimumDate = Date()
            calendar.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
            calendar.selectedStartDate = Date()
            calendar.selectedEndDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            calendar.selectedColor = UIColor(red: 0.00, green: 0.82, blue: 1.00, alpha: 1)
            calendar.titleText = "Select Trip Dates"
            let navigationController = UINavigationController(rootViewController: calendar)
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        doneClicked = true
        UserDetails.previousDateSelected = false
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        UserDetails.tripStartDatePreviousSelected = startDate
        UserDetails.tripEndDatePreviousSelected = endDate
        firstDate = dateformate(format: "MMM dd", date: startDate) + " - " +  dateformate(format: "MMM dd", date: endDate)
        year = dateformate(format: "yyyy", date: startDate)
        dates = dateformate(format: "d/MM/yy", date: startDate) + " - " +  dateformate(format: "d/MM/yy", date: endDate)
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
        editeTipeMenu.reloadData()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}


extension EditeTripController{
    func setUpConstraintsToAttributes(){
        switch UIDevice().type {
        case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
            editeTripNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)
            
            confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 85.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
        default:
            editeTripNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
            
            confirmButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 65.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
        }
        editeTripTitle.layoutAnchor(top: nil, left: nil, bottom: editeTripNavigationView.bottomAnchor, right: nil, centerX: editeTripNavigationView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
        
        EditTripBackButton.layoutAnchor(top: nil, left: editeTripNavigationView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: editeTripTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        
        editeTipeMenu.layoutAnchor(top: editeTripNavigationView.bottomAnchor, left: view.leftAnchor, bottom: confirmButton.topAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 50.0, paddingLeft: 17.0, paddingBottom: 50.0, paddingRight: 16.0, width: 0.0, height: 0.0, enableInsets: true)
        
        errorMessage.layoutAnchor(top: editeTipeMenu.tableFooterView?.topAnchor, left: editeTipeMenu.tableFooterView?.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 10.0, paddingBottom: 0.0, paddingRight: 0.0, width: (editeTipeMenu.tableFooterView?.frame.width)!, height: 10, enableInsets: true)
    }
}

extension EditeTripController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddNameCell", for: indexPath) as? editeAddNameCell
            
            if cell == nil {
                cell = editeAddNameCell.init(style: .default, reuseIdentifier: "AddNameCell")
            }
            
            cell?.tripName.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1)])
            cell?.tripName.autocorrectionType = .no
            cell?.selectionStyle = .none
            cell?.tripName.text = Tripname
            cell?.tripName.addHideinputAccessoryView()
            return cell!
        }else if indexPath.row == 1{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "SelectDatesCell", for: indexPath) as? EditeDateCell
            
            if cell == nil {
                cell = EditeDateCell.init(style: .default, reuseIdentifier: "SelectDatesCell")
            }
            
            
            cell?.tripDates.text = dates
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropDownTapped))
            cell?.tripDates.isUserInteractionEnabled = true
            cell?.tripDates.addGestureRecognizer(tapGesture)
            cell?.selectionStyle = .none
            cell?.dropDownButton.addTarget(self, action: #selector(dropDownTapped), for: .touchUpInside)
            return cell!
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCurrencyCell", for: indexPath) as! EditeChooseCurrencyCell
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseCurrencyTapped))
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(tapGesture)
            cell.selectionStyle = .none
            
            if iconUpdateFlag == true {
                cell.iconImage.image = UIImage(named: iconName)
                cell.countryName.text = countryName
            }else{
                cell.iconImage.image = UIImage(named: countryIcon)
                cell.countryName.text = countryName
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalBudgetCell", for: indexPath) as! EditeTotelBudgetCell
            cell.totalBudget.attributedPlaceholder = NSAttributedString(string: "Enter Budget",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 0.7)])
            cell.totalBudget.delegate = self
            cell.totalBudget.autocorrectionType = .no
            cell.selectionStyle = .none
            if iconUpdateFlag == true {
                let budgetValue = matches(for: RegExpression.shared.NumberRegex, in: budget)
                var sym = getSymbolForCurrencyCode(code: symbole)
                for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == sym{
                    sym = valueArray[j]
                }
                cell.totalBudget.text = "\(sym) \(budgetValue.joined())"
            }else{
                let budgetValue = matches(for: RegExpression.shared.NumberRegex, in: budget)
                let budgetSymbol = matches(for: RegExpression.shared.CodesRegex, in: budget)
                var symbol = budgetSymbol.joined()
                for j in 0..<(symboleGetArray.count) where symboleGetArray[j] == budgetSymbol.joined(){
                    symbol = valueArray[j]
                }
                cell.totalBudget.text = "\(symbol) \(budgetValue.joined())"
            }
            cell.totalBudget.addHideinputAccessoryView()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    @objc func chooseCurrencyTapped(){
        UserDetails.ClickBool.AddTripControllerClicked = false
        presentDissmiss(controller: "CountryViewController")
    }
}


extension EditeTripController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
//        switch string {
//        case "0","1","2","3","4","5","6","7","8","9":
//            return true
//        case ".":
//            var decimalCount = 0
//            if textField.keyboardType == .decimalPad {
//                let array = Array(textField.text!)
//                for character in array {
//                    if character == "." {
//                        decimalCount = decimalCount + 1
//                    }
//                }
//            }
//            if decimalCount >= 1 {
//                return false
//            } else {
//                return true
//            }
//        default:
//            let array = Array(string)
//            if array.count == 0 {
//                return true
//            }
//            return false
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let TotalBudgetCellIndexPath = IndexPath(row: 3, section: 0)
        guard let totelCell: EditeTotelBudgetCell = editeTipeMenu.cellForRow(at: TotalBudgetCellIndexPath) as? EditeTotelBudgetCell else { return }
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
            let myheight = editeTipeMenu.frame.height
            // Get the top Y point where the keyboard will finish on the view
            let keyboardEndPoint = myheight - keyboardFrame.height
            // Get the the bottom Y point of the textInput and transform it to the currentView coordinates.
            guard let inputTextFeild = inputActive else { return }
            if let pointInTable = inputTextFeild.superview?.convert(inputTextFeild.frame.origin, to: editeTipeMenu) {
                let textFieldBottomPoint = (pointInTable.y + inputTextFeild.frame.size.height -  100)
                // Finally check if the keyboard will cover the textInput
                if keyboardEndPoint <= textFieldBottomPoint {
                    editeTipeMenu.contentOffset.y = textFieldBottomPoint - keyboardEndPoint
                } else {
                    editeTipeMenu.contentOffset.y = 0
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        editeTipeMenu.contentOffset.y = 0
    }
    
}



