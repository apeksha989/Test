//
//  HomeViewController.swift
//  Haggle
//
//  Created by Anil Kumar on 01/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import AVKit

var lensFlag   = false
var haggleFlag = false

class HomeViewController: UIViewController {
    
    var imageName               = ["Wallet_CellP_Background", "Lens_Cell_Background", "Haggle_Cell_Background"]
    var titleArray              = ["Wallet", "Lens", "Haggle"]
    var tripBudgetArray         = ["Total Trip Budget", "", ""]
    var homeCurrencyArray       = ["Home Currency", "Trip Currency", "Trip Currency"]
    let cellPercentWidth: CGFloat = 0.6
    
    var currrentDate            = Date()
    var todayDate               = String()
    var validDate               = String()
    let dateFormatter = DateFormatter()
    
    var centeredCollectionViewFlowLayout = CenteredCollectionViewFlowLayout()
    
    lazy var dimView              = UIView(frame: UIScreen.main.bounds)
    lazy var noCliked             = false
    lazy var collectionView = UICollectionView()//collectionViewClass(controller: self)
    
    let popView = UIViewFactory()
        .cornerRadious(value: 13)
        .backgroundColor(color: .white)
        .build()
    
    let line = UIViewFactory()
        .borderWith(value: 1.0)
        .borderColor(color: UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0))
        .build()
    
    let pageControl = UIPageControlFactory()
        .setNumberOfPages(value: 3)
        .setCurrentPageIndicatorTintColor(color: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
        .pageIndicatorTintColor(color: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 0.33))
        .build()
  
    let tapBarView = UIViewFactory()
        .build()
    
    let containerView = UIViewFactory()
        .build()
    
    let profileImage = UIImageFactory()
        .build()
    
    let walletImage  = UIImageFactory()
        .build()
    
    let lensImage    = UIImageFactory()
        .build()
    
    let haggleImage  = UIImageFactory()
        .build()
    
    let  imageview = UIImageFactory()
        .CornerRadious(radious: 5)
        .setImage(imageString: "PopUp_BGImage")
        .build()
    
    let homeScreenBackGround = UIImageFactory()
        .setImage(imageString: "MenuBar_Background")
        .build()
    
    let profileName = UILabelFactory(text: "")
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 22)!)
        .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
        .textAlignment(with: .center)
        .build()
    
    let currencyLabel = UILabelFactory(text: "")
        .numberOf(lines: 0)
        .textAlignment(with: .center)
        .textColor(with: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0))
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 18)!)
        .lineBreaking(mode: .byWordWrapping)
        .build()
    
    let menuButton = UIButtonFactory(title: "")
        .setBackgroundImage(image: "Menu")
        .addTarget(self, action:  #selector(menuButtonTapped(sender:)), for: .touchUpInside)
        .build()
    
    let lensLabel = UILabelFactory(text: "LENS")
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 12)!)
        .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
        .build()
    
    let walletLabel = UILabelFactory(text: "WALLET")
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 12)!)
        .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
        .build()
    
    let haggleLabel = UILabelFactory(text: "HAGGLE")
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 12)!)
        .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
        .build()
    
    let patentLabel = UILabelFactory(text: "")
        .textFonts(with: UIFont(name: "Montserrat-Regular", size: 11)!)
        .textAlignment(with: .center)
        .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
        .numberOf(lines: 0)
        .build()
    
    let homeLabel = UILabelFactory(text: "Home Currency")
        .textAlignment(with: .center)
        .textColor(with: .white)
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
        .build()
    
    let yesButton = UIButtonFactory(title: "Yes")
        .setTitileColour(with: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0))
        .textAlignmentButton(with: .center)
        .backgroundColour(with: .white)
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 20)!)
        .addTarget(self, action: #selector(yesBtnClicked), for: .touchUpInside)
        .build()
    
    let noButton = UIButtonFactory(title: "No")
        .setTitileColour(with: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0))
        .textAlignmentButton(with: .center)
        .backgroundColour(with: .white)
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 20)!)
        .addTarget(self, action: #selector(noBtnClicked), for: .touchUpInside)
        .build()
    
    let valueArray = RegExpression.shared.codeToSymbole.map {($0.value)}
    let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        if !UserDetails.tripDate.isEmpty{
            if !UserDetails.tripStartedFlag{
                let value = UserDetails.tripDate.map {($0.value)}
                for i in value {
                    if !i.isGreaterThan(currrentDate){
                        if i.isEqualTo(currrentDate) || i.isSmallerThan(currrentDate){
                            UserDetails.startDates.append(i)
                        }
                    }
                }
                
                if !UserDetails.startDates.isEmpty{
                    findHaggleTripFlag()
                }
            }
        }
        
        let countryCode = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationCode") as? String
        currencyLabel.text = "Your Home currency has been detected as \(countryCode!). Is this correct? \n \nThis can be changed anytime via the Settings menu."
        
        if UserDetails.homeYesTapped == false {
            UserDetails.homeYesTapped = true
            slideMenuController()?.toggleLeft()
        }
        
        if (UserDetails.PercentageCalculation.scannedAmount.isEmpty && UserDetails.shared.tripArray.isEmpty) {
            if UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty {
                let UpdateWalletValues = ["0.00","0.00"]
                convertionApi(countryCode!, "AUD", "1")
                
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateWalletValues, forKey: "WalletUpdate")
            }else{
                let UpdateWalletValues = ["0.00","0.00"]
                convertionApi(UserDetails.ChangeHomeCurrency.homeCurrencyCode, "AUD", "1")
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateWalletValues, forKey: "WalletUpdate")
            }
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
        }else if !UserDetails.PercentageCalculation.scannedAmount.isEmpty && UserDetails.shared.tripArray.isEmpty {
            let amount = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.PercentageCalculation.scannedAmount)
            if UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty {
              if haggleFlag && lensFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateLensValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                let UpdateHaggleValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateLensValues, forKey: "LensUpdate")
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateHaggleValues, forKey: "HaggleUpdate")
                
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
                
                let indexPath1 = IndexPath(item: 2, section: 0)
                self.collectionView.reloadItems(at: [indexPath1])
              }else if haggleFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateHaggleValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateHaggleValues, forKey: "HaggleUpdate")
                let indexPath1 = IndexPath(item: 2, section: 0)
                self.collectionView.reloadItems(at: [indexPath1])
              }else if lensFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateLensValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateLensValues, forKey: "LensUpdate")
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
              }else {
                    convertionApi(UserDetails.haggleTargetCode, countryCode!,amount.joined())
                }
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
            }else {
              if haggleFlag && lensFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateLensValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                let UpdateHaggleValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateLensValues, forKey: "LensUpdate")
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateHaggleValues, forKey: "HaggleUpdate")
                
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
                
                let indexPath1 = IndexPath(item: 2, section: 0)
                self.collectionView.reloadItems(at: [indexPath1])
              }else if haggleFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateHaggleValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateHaggleValues, forKey: "HaggleUpdate")
                let indexPath1 = IndexPath(item: 2, section: 0)
                self.collectionView.reloadItems(at: [indexPath1])
              }else if lensFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateLensValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateLensValues, forKey: "LensUpdate")
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
              }else {
                   convertionApi(UserDetails.haggleTargetCode, UserDetails.ChangeHomeCurrency.homeCurrencyCode,amount.joined())
                }
            }
            let UpdateWalletValues = ["0.00","0.00"]
            UserDetails.HomeSreenUpdateValues.updateValue(UpdateWalletValues, forKey: "WalletUpdate")
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
        }else if UserDetails.PercentageCalculation.scannedAmount.isEmpty && !UserDetails.shared.tripArray.isEmpty{
            if UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty {
                convertionApi(countryCode!, "AUD", "1")
            }else{
              if let key = DateValidation.sharedInstance.checkHomeScreenUpdates(Controller: self, currentDate: Date()) {
                    let TotBudget = UserDetails.shared.tripArray[key]?["totelBudjet"] as? String
                    let getCode = UserDetails.shared.tripArray[key]?["code"] as? String
                    let numberOnly = self.matches(for: RegExpression.shared.NumberRegex, in: TotBudget!)
                    convertionUpdateToHomeScreen(BaseCode: getCode!, targetCode: UserDetails.ChangeHomeCurrency.homeCurrencyCode, amount: numberOnly.joined(),TotalBudget: TotBudget!)
                }else{
                    let UpdateValues = ["0.00","0.00"]
                    UserDetails.HomeSreenUpdateValues.updateValue(UpdateValues, forKey: "WalletUpdate")
                    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
                }
                convertionApi(UserDetails.ChangeHomeCurrency.homeCurrencyCode, "AUD", "1")
            }
            StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
        }else if !UserDetails.PercentageCalculation.scannedAmount.isEmpty && !UserDetails.shared.tripArray.isEmpty{
            let amount = matches(for: RegExpression.shared.NumberRegex, in: UserDetails.PercentageCalculation.scannedAmount)
            if UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty {
              if haggleFlag && lensFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateLensValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                let UpdateHaggleValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateLensValues, forKey: "LensUpdate")
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateHaggleValues, forKey: "HaggleUpdate")
                
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
                
                let indexPath1 = IndexPath(item: 2, section: 0)
                self.collectionView.reloadItems(at: [indexPath1])
              }else if haggleFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateHaggleValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateHaggleValues, forKey: "HaggleUpdate")
                let indexPath1 = IndexPath(item: 2, section: 0)
                self.collectionView.reloadItems(at: [indexPath1])
              }else if lensFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateLensValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateLensValues, forKey: "LensUpdate")
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
              }else {
                   convertionApi(countryCode!, UserDetails.haggleTargetCode,amount.joined())
                }
            }else {
              if let key = DateValidation.sharedInstance.checkHomeScreenUpdates(Controller: self, currentDate: Date()) {
                    let TotBudget = UserDetails.shared.tripArray[key]?["totelBudjet"] as? String
                    let getCode = UserDetails.shared.tripArray[key]?["code"] as? String
                    let numberOnly = self.matches(for: RegExpression.shared.NumberRegex, in: TotBudget!)
                    convertionUpdateToHomeScreen(BaseCode: getCode!, targetCode: UserDetails.ChangeHomeCurrency.homeCurrencyCode, amount: numberOnly.joined(),TotalBudget: TotBudget!)
                }else{
                    let UpdateValues = ["0.00","0.00"]
                    UserDetails.HomeSreenUpdateValues.updateValue(UpdateValues, forKey: "WalletUpdate")
                    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
                }
              if haggleFlag && lensFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateLensValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                let UpdateHaggleValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateLensValues, forKey: "LensUpdate")
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateHaggleValues, forKey: "HaggleUpdate")
                
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
                
                let indexPath1 = IndexPath(item: 2, section: 0)
                self.collectionView.reloadItems(at: [indexPath1])
              }else if haggleFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateHaggleValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateHaggleValues, forKey: "HaggleUpdate")
                let indexPath1 = IndexPath(item: 2, section: 0)
                self.collectionView.reloadItems(at: [indexPath1])
              }else if lensFlag {
                haggleFlag = false
                lensFlag = false
                let UpdateLensValues = [UserDetails.PercentageCalculation.ConvertedAmount,UserDetails.PercentageCalculation.scannedAmount]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateLensValues, forKey: "LensUpdate")
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
              }else {
                    convertionApi(UserDetails.ChangeHomeCurrency.homeCurrencyCode, UserDetails.haggleTargetCode,amount.joined())
                }
            }
        }
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
        if noCliked == true{
            noCliked = false
            dimView.isHidden = true
            setView(view: popView, hidden: true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updatingValues), name: .UpdatedHomeScreenValues, object: nil)
    }
    @objc func updatingValues() {
        self.collectionView.reloadData()
    }
    func convertionApi(_ base: String,_ target: String,_ amount: String){
        debugPrint("<---------Convertion Sending NetWork Request From HomeViewController Please Wait------------>😁")
        Networking.sharedInstance.convertion(baseCurrency: base, targetCurrency: target, Value: amount) { (status, error, result) in
            if status{
                let UpdateLensValues = ["\(amount) \(base)","\(result) \(target)"]
                var symbol = self.getSymbolForCurrencyCode(code: base)
                var targetsymbol = self.getSymbolForCurrencyCode(code: target)
                
                for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == base{
                    symbol = self.valueArray[j]
                }
                
                for j in 0..<(self.symboleGetArray.count) where self.symboleGetArray[j] == target{
                    targetsymbol = self.valueArray[j]
                }
                
                let UpdateHaggleValues = ["\(symbol) \(amount)","\(targetsymbol) \(result)"]
                
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateLensValues, forKey: "LensUpdate")
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateHaggleValues, forKey: "HaggleUpdate")
                
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
                
                let indexPath1 = IndexPath(item: 2, section: 0)
                self.collectionView.reloadItems(at: [indexPath1])
                
                debugPrint("<---------Convertion Success------------>😄")
            }else{
                debugPrint("<---------Failed Convertion------------>😡")
            }
        }
    }
    
    
    func convertionUpdateToHomeScreen(BaseCode:String,targetCode:String,amount:String, TotalBudget: String){
        debugPrint("<---------Convertion Sending NetWork Request From AddTripController Please Wait------------>😺")
        var Amount = ""
        Networking.sharedInstance.convertion(baseCurrency: BaseCode, targetCurrency: targetCode, Value: amount) { (success, error, result) in
            if success {
                debugPrint("<---------Convertion Success------------>😄")
                let finalvalue = self.matches(for: RegExpression.shared.NumberRegex, in: result)
                let tripCode = self.matches(for: RegExpression.shared.CodesRegex, in: TotalBudget)
                let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
                Amount = final
                let UpdateValues = [amount+" "+tripCode.joined(),Amount+" "+targetCode]
                UserDetails.HomeSreenUpdateValues.updateValue(UpdateValues, forKey: "WalletUpdate")
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
                let indexPath = IndexPath(item: 0, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
            }else{
                debugPrint("<---------Failed Convertion------------>")
                self.showConfirmAlert(title: "", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: { (action) in
                })
            }
        }
    }
    
    deinit {
        Networking.destroy()
        collectionView.delegate = nil
        print("Deinitialization HomeController ----> ",HomeViewController.self)
    }
    
    func findHaggleTripFlag(){
        let sorted =  UserDetails.startDates.map{ ( ($0 < Date() ? 1 : 0), $0) }.sorted(by:<).map{$1}
        let validDate = sorted.last
        if let selectedKey = UserDetails.tripDate.someKey(forValue: (validDate!)){
            if let tripFlag = UserDetails.shared.tripArray[selectedKey]?["countryIcon"] as? String{
                UserDetails.haggleHomeIcon = tripFlag
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleHomeIcon, storeType: "haggleHomeIcon")
            }
            if let tripCode = UserDetails.shared.tripArray[selectedKey]?["code"] as? String{
                UserDetails.haggleTargetCode = tripCode
                StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.haggleTargetCode, storeType: "haggleTargetCode")
                //                StrongBoxController.sharedInstance.storeUserDefaultDataTypes(data: haggleTargetCode, storeType: "haggleTargetCode")
            }
        }
    }
    
    func dateValidation(){
        let date = dateFormatter.string(from: currrentDate)
        if todayDate == date{
            UserDetails.tripStartedFlag = true
        }else{
            todayDate = dateFormatter.string(from: currrentDate)
            UserDetails.tripStartedFlag = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("<---------HomeViewController------------>😀")
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: centeredCollectionViewFlowLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        RestoreingUserDefault()
        dateFormatter.dateStyle = .short
        
        if !UserDetails.tripDate.isEmpty{
            if todayDate.isEmpty{
                todayDate = dateFormatter.string(from: currrentDate)
                dateValidation()
            }else{
                dateValidation()
            }
        }
        
        navigationController?.navigationBar.isHidden = true
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        collectionView.register(StoryboardCollectionViewCell.self, forCellWithReuseIdentifier: "cellreuse")
        collectionView.backgroundColor = .white
        
        view.addSubview(homeScreenBackGround)
        homeScreenBackGround.addSubview(containerView)
        view.addSubview(menuButton)
        containerView.addSubview(profileImage)
        view.addSubview(profileName)
        view.addSubview(tapBarView)
        view.addSubview(collectionView)
        view.addSubview(patentLabel)
        view.addSubview(pageControl)
        view.insertSubview(pageControl, at: 0)
        
        homeScreenBackGround.bringSubviewToFront(containerView)
        view.bringSubviewToFront(menuButton)
        containerView.bringSubviewToFront(profileImage)
        view.bringSubviewToFront(profileName)
        view.bringSubviewToFront(tapBarView)
        view.bringSubviewToFront(collectionView)
        view.bringSubviewToFront(patentLabel)
        view.bringSubviewToFront(pageControl)
        
        
        setUpTabBarViews()
        setupViews()
        setupAutoLayout()
        setUpConstraintsToAttributes()
        
        profileName.text = StrongBoxController.sharedInstance.nameUnArcheive() != "" ? "\(StrongBoxController.sharedInstance.nameUnArcheive())" : ""
        
        if let image = StrongBoxController.sharedInstance.imageUnArcheive(){
            profileImage.image = image
        }else{
            profileImage.image = getImageFromBundleClass.getImageFromBundle("profileIcon")
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        
        //Get the reference to the CenteredCollectionViewFlowLayout (REQURED)
        centeredCollectionViewFlowLayout = (collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        
        //Modify the collectionView's decelerationRate (REQURED)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        //Assign delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Configure the required item size (REQURED)
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: view.bounds.width * cellPercentWidth + view.bounds.width/4,
            height: view.bounds.height * cellPercentWidth * cellPercentWidth
        )
        
        // Configure the optional inter item spacing (OPTIONAL)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 0
        gustureAction()
        
        if let _ = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "HomePagePopUp") as? Bool{
            StrongBoxController.sharedInstance.removeUserDefaultValues(RetriveKey: "HomePagePopUp")
            popView.isHidden = false
            dimView.isHidden = false
        }else{
            popView.isHidden = true
            dimView.isHidden = true
        }
      dateDetector()
    }
    
    func gustureAction(){
        let walletTapGuesture = UITapGestureRecognizer(target: self, action: #selector(walletImageTapped))
        walletImage.addGestureRecognizer(walletTapGuesture)
        walletImage.isUserInteractionEnabled = true
        
        let lensTapGuesture = UITapGestureRecognizer(target: self, action: #selector(lensImageTapped))
        lensImage.addGestureRecognizer(lensTapGuesture)
        lensImage.isUserInteractionEnabled = true
        
        let haggleTapGuesture = UITapGestureRecognizer(target: self, action: #selector(haggleImageTapped))
        haggleImage.addGestureRecognizer(haggleTapGuesture)
        haggleImage.isUserInteractionEnabled = true
        
    }
    
    @objc func walletImageTapped(){
        guard let currenctIndex = getCurrentPage() else { return }
        if currenctIndex == 2{
            let nextItem = NSIndexPath(row: currenctIndex - 2, section: 0)
            collectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        }else if currenctIndex == 1{
            let nextItem = NSIndexPath(row: currenctIndex - 1, section: 0)
            collectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        }else{
            let nextItem = NSIndexPath(row: currenctIndex , section: 0)
            collectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        }
    }
    
    @objc func lensImageTapped(){
        guard let currenctIndex = getCurrentPage() else { return }
        if currenctIndex == 2{
            let nextItem = NSIndexPath(row: currenctIndex - 1, section: 0)
            collectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        }else if currenctIndex == 0{
            let nextItem = NSIndexPath(row: currenctIndex + 1 , section: 0)
            collectionView.scrollToItem(at: nextItem as IndexPath, at: .right, animated: true)
        }
    }
    
    @objc func haggleImageTapped(){
        guard let currenctIndex = getCurrentPage() else { return }
        if currenctIndex == 1{
            let nextItem = NSIndexPath(row: currenctIndex + 1 , section: 0)
            collectionView.scrollToItem(at: nextItem as IndexPath, at: .right, animated: true)
        }else if currenctIndex == 0{
            let nextItem = NSIndexPath(row: currenctIndex + 2 , section: 0)
            collectionView.scrollToItem(at: nextItem as IndexPath, at: .right, animated: true)
        }
    }
    
    func getCurrentPage()-> Int?{
        if let currentCenterIndex = centeredCollectionViewFlowLayout.currentCenteredPage {
            return currentCenterIndex
        }else{
            return nil
        }
    }
    func setUpTabBarViews(){
        tapBarView.addSubview(walletImage)
        tapBarView.addSubview(walletLabel)
        tapBarView.addSubview(lensImage)
        tapBarView.addSubview(lensLabel)
        tapBarView.addSubview(haggleImage)
        tapBarView.addSubview(haggleLabel)
        tapBarView.bringSubviewToFront(walletImage)
        tapBarView.bringSubviewToFront(walletLabel)
        tapBarView.bringSubviewToFront(lensImage)
        tapBarView.bringSubviewToFront(lensLabel)
        tapBarView.bringSubviewToFront(haggleImage)
        tapBarView.bringSubviewToFront(haggleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.layer.cornerRadius = 60.0
        containerView.layer.shadowColor = UIColor(red: 0.12, green: 0.03, blue: 0.27, alpha: 0.20).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        containerView.layer.shadowOpacity = 0.2
        
        profileImage.layer.cornerRadius = 60.0
        profileImage.clipsToBounds = true
        
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 0.33)
        
    }
    @objc func menuButtonTapped(sender: UIButton) {
        slideMenuController()?.toggleLeft1()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            popOrPushToViewController("WalletMainController")
        }else if indexPath.row == 1{
            askPermission()
        }else if indexPath.row == 2{
            popOrPushToViewController("HaggleMainScreen")
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellreuse", for: indexPath) as! StoryboardCollectionViewCell
        cell.backgroundImage.image = getImageFromBundleClass.getImageFromBundle(imageName[indexPath.row])
        
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.homeCurrencyLabel.text = homeCurrencyArray[indexPath.row]
        cell.tripBudgetLabel.text = tripBudgetArray[indexPath.row]
        
        if indexPath.row == 0 {
            let values = UserDetails.HomeSreenUpdateValues["WalletUpdate"]
            cell.tripBudgetAmountLabel.text = values?[0]
            cell.homeCurrencyAmountLabel.text = values?[1]
        }else if indexPath.row == 1 {
            let values = UserDetails.HomeSreenUpdateValues["LensUpdate"]
            if let parsingValues = values{
                cell.tripBudgetAmountLabel.text = parsingValues[0]
                cell.homeCurrencyAmountLabel.text = parsingValues[1]
            }
        } else if indexPath.row == 2{
            let values = UserDetails.HomeSreenUpdateValues["HaggleUpdate"]
            if let parsingValues = values{
                cell.tripBudgetAmountLabel.text = parsingValues[0]
                cell.homeCurrencyAmountLabel.text = parsingValues[1]
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentCenterIndex = centeredCollectionViewFlowLayout.currentCenteredPage else {return}
        pageControl.currentPage = currentCenterIndex
        if currentCenterIndex == 0{
            UIView.animate(withDuration: 2) { [weak self] in
                self?.patentLabel.text = "Create your travel budget and alerts, store your travel documents and create your digital ID"
            }
            walletImage.image = getImageFromBundleClass.getImageFromBundle("Wallet_Blue")
            walletLabel.textColor = #colorLiteral(red: 0.209812969, green: 0.5855591893, blue: 0.7919145226, alpha: 1)
            lensImage.image = getImageFromBundleClass.getImageFromBundle("Currency_Exchange_Gray")
            lensLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
            haggleImage.image = getImageFromBundleClass.getImageFromBundle("Handshake_Gray")
            haggleLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
        }else if currentCenterIndex == 1{
            UIView.animate(withDuration: 2) { [weak self] in
                self?.patentLabel.text = "Use our camera to scan any price for an instant currency conversion*"
            }
            walletImage.image = getImageFromBundleClass.getImageFromBundle("Wallet_Gray")
            walletLabel.textColor = #colorLiteral(red: 0.8635390401, green: 0.8635593057, blue: 0.863548398, alpha: 1)
            lensImage.image = getImageFromBundleClass.getImageFromBundle( "Currency Exchange_Blue")
            lensLabel.textColor = #colorLiteral(red: 0.209812969, green: 0.5855591893, blue: 0.7919145226, alpha: 1)
            haggleImage.image = getImageFromBundleClass.getImageFromBundle("Handshake_Gray")
            haggleLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
        }else{
            UIView.animate(withDuration: 2) { [weak self] in
                self?.patentLabel.text = "A clever tool, to allow you to quickly negotiate prices while on a trip"
            }
            walletImage.image = getImageFromBundleClass.getImageFromBundle("Wallet_Gray")
            walletLabel.textColor = #colorLiteral(red: 0.8635390401, green: 0.8635593057, blue: 0.863548398, alpha: 1)
            lensImage.image = getImageFromBundleClass.getImageFromBundle("Currency_Exchange_Gray")
            lensLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
            haggleImage.image = getImageFromBundleClass.getImageFromBundle("Handshake_Blue")
            haggleLabel.textColor = #colorLiteral(red: 0.209812969, green: 0.5855591893, blue: 0.7919145226, alpha: 1)
        }
    }
}

extension HomeViewController{
    
    func setupViews() {
        
        setView(view: popView, hidden: false)
        view.addSubview(dimView)
        view.addSubview(popView)
        view.bringSubviewToFront(popView)
        popView.addSubview(imageview)
        popView.addSubview(homeLabel)
        popView.addSubview(currencyLabel)
        popView.addSubview(yesButton)
        popView.addSubview(line)
        popView.addSubview(noButton)
    }
    
    @objc func yesBtnClicked(){
        dimView.isHidden = true
        setView(view: popView, hidden: true)
    }
    
    @objc func noBtnClicked(){
        noCliked = true
        //    dimView.isHidden = true
        //    setView(view: popView, hidden: true)
        UserDetails.ChangeHomeCurrency.homeCurrency = false
        presentDissmiss(controller: "CountryViewController")
    }
    
    func setRootController(){
        let mainViewController = storyboardViewControllerFromString("HomeViewController")
        let leftViewController = storyboardViewControllerFromString("LeftViewController")
        let slideMenuController = ExSlideMenuController(mainViewController: mainViewController!, leftMenuViewController: leftViewController!)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
        navigationController?.pushViewController(slideMenuController, animated: true)
    }
}

extension HomeViewController {
    func askPermission() {
        let cameraPermissionStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraPermissionStatus {
        case .authorized:
            popOrPushToViewController("RealtimeCaptureController")
        case .denied:
            let alert = UIAlertController(title: "Sorry :(" , message: "But could you please grant permission for camera within device settings",  preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel,  handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        case .restricted:
            print("restricted")
        default:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                [weak self]
                (granted :Bool) -> Void in
                if granted == true {
                    DispatchQueue.main.async(){ [weak self] in
                        //   guard let self = self else { return }Changes made by Apeksha
                        guard let `self` = self else { return }
                         self.popOrPushToViewController("RealtimeCaptureController")
                    }
                }else {
                    DispatchQueue.main.async(){
                        let alert = UIAlertController(title: "WHY?" , message:  "Camera it is the main feature of our application", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            
                        })
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            });
        }
    }
}

extension HomeViewController{
    
    func setupAutoLayout() {
        
        popView.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: view.frame.size.width-40, height: view.frame.height/2, enableInsets: true)
        
        imageview.layoutAnchor(top: popView.topAnchor, left: popView.leftAnchor, bottom: nil, right: popView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 67, enableInsets: true)
        
        homeLabel.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: imageview.centerXAnchor, centerY: imageview.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        currencyLabel.layoutAnchor(top: nil, left: popView.leftAnchor, bottom: nil, right: popView.rightAnchor, centerX: nil, centerY: popView.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        yesButton.layoutAnchor(top: nil, left: popView.leftAnchor, bottom: popView.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: view.frame.width/2-21, height: 70.0, enableInsets: true)
        
        noButton.layoutAnchor(top: nil, left: nil, bottom: popView.bottomAnchor, right: popView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: view.frame.width/2-21, height: 70.0, enableInsets: true)
        
        line.layoutAnchor(top: nil, left: yesButton.rightAnchor, bottom: popView.bottomAnchor, right: noButton.leftAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 20.0, paddingRight: 0.0, width: 0.0, height: 40.0, enableInsets: true)
        
    }
    
    func setUpConstraintsToAttributes() {
        
        switch UIDevice().type {
        case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
            homeScreenBackGround.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/3.4 + 60, enableInsets: true)
            containerView.layoutAnchor(top: homeScreenBackGround.topAnchor, left: nil, bottom: nil, right: nil, centerX: homeScreenBackGround.centerXAnchor, centerY: nil, paddingTop: view.frame.size.height/8.3 + 60, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 120.0, height: 120.0, enableInsets: true)
            profileImage.layoutAnchor(top: homeScreenBackGround.topAnchor, left: nil, bottom: nil, right: nil, centerX: homeScreenBackGround.centerXAnchor, centerY: nil, paddingTop: view.frame.size.height/8.3 + 60, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 120.0, height: 120.0, enableInsets: true)
            menuButton.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: view.frame.size.height/18.5 + 20, paddingLeft: 22.0, paddingBottom: 0.0, paddingRight: 0.0, width: 26.0, height: 20.0, enableInsets: true)
            pageControl.layoutAnchor(top: patentLabel.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 10.0, paddingLeft: 0.0, paddingBottom: 10, paddingRight: 0.0, width: 54, height: 12, enableInsets: true)
            
        default:
            homeScreenBackGround.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/3.4, enableInsets: true)
            containerView.layoutAnchor(top: homeScreenBackGround.topAnchor, left: nil, bottom: nil, right: nil, centerX: homeScreenBackGround.centerXAnchor, centerY: nil, paddingTop: view.frame.size.height/8.3, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 120.0, height: 120.0, enableInsets: true)
            profileImage.layoutAnchor(top: homeScreenBackGround.topAnchor, left: nil, bottom: nil, right: nil, centerX: homeScreenBackGround.centerXAnchor, centerY: nil, paddingTop: view.frame.size.height/8.3, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 120.0, height: 120.0, enableInsets: true)
            menuButton.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: view.frame.size.height/18.5, paddingLeft: 22.0, paddingBottom: 0.0, paddingRight: 0.0, width: 26.0, height: 20.0, enableInsets: true)
            pageControl.layoutAnchor(top: patentLabel.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 10.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 54, height: 12, enableInsets: true)
        }
        profileName.layoutAnchor(top: homeScreenBackGround.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 26, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: view.frame.size.width/2 + view.frame.size.width/5, height: 28.0, enableInsets: true)
        tapBarView.layoutAnchor(top: profileName.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 17.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 267, height: 75, enableInsets: true)
        walletImage.layoutAnchor(top: tapBarView.topAnchor, left: tapBarView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 5.0, paddingBottom: 0.0, paddingRight: 0.0, width: 50, height: 50, enableInsets: true)
        walletLabel.layoutAnchor(top: nil, left: tapBarView.leftAnchor, bottom: tapBarView.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 2.0, paddingBottom: 0.0, paddingRight: 0.0, width: 53, height: 17, enableInsets: true)
        lensImage.layoutAnchor(top: tapBarView.topAnchor, left: nil, bottom: nil, right: nil, centerX: tapBarView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 50, height: 50, enableInsets: true)
        lensLabel.layoutAnchor(top: nil, left: nil, bottom: tapBarView.bottomAnchor, right: nil, centerX: tapBarView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 33.0, height: 17.0, enableInsets: true)
        haggleImage.layoutAnchor(top: tapBarView.topAnchor, left: nil, bottom: nil, right: tapBarView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 5.0, width: 50.0, height: 50.0, enableInsets: true)
        haggleLabel.layoutAnchor(top: nil, left: nil, bottom: tapBarView.bottomAnchor, right: tapBarView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 53.0, height: 17.0, enableInsets: true)
        collectionView.layoutAnchor(top: tapBarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 16.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.height/2.9, enableInsets: true)
        patentLabel.layoutAnchor(top: collectionView.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 13.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 300, height: 37, enableInsets: true)
    }
    
}

extension HomeViewController {
    func RestoreingUserDefault(){
        let tripData = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "tripArrayStore")
        if tripData != nil {
            
            if let tripArrayRetrive = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "tripArrayStore") as? [Int:[String:Any]]{
                UserDetails.shared.tripArray = tripArrayRetrive
            }
            if let createCategoryRetrive = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "creatCategoryArray") as? [Int:[String:Any]]{
                UserDetails.creatCategoryArray = createCategoryRetrive
            }
            if let totelAmountRetive = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "totalAmount") as?  [Int:[String:[String]]]{
                UserDetails.totalAmount = totelAmountRetive
            }
            if let Id = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "tripId") as? Int{
                UserDetails.tripId = Id
            }
            
            if let notificationArrayRetrival = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "notificationArray") as? [[String]] {
                UserDetails.shared.notificationArray = notificationArrayRetrival
            }
            
            if let arrayCat = StrongBoxController.sharedInstance.retriveExpandableArray(RetriveKey: "categoryWholeArray"){
                UserDetails.categoryWholeArray = arrayCat
            }
            
            let dictValue = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "dict1") as? [Int : [String : [String]]]
            if dictValue != nil{
                UserDetails.shared.dict1 = dictValue!
            }
            
            if let colorArrayRandomPickerRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "colorArrayRandomPicker") as? [Int : [String : [Data]]] {
                UserDetails.colorArrayRandomPicker = colorArrayRandomPickerRetrivel
            }
            
            if let addexpensiveRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "addExpensiveValue.code") as? String{
                UserDetails.addExpensiveValue.code = addexpensiveRetrivel
            }
            if let homeCurrencyCodeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "ChangeHomeCurrency.homeCurrencyCode") as? String,
                let homeCurrencyIconRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "ChangeHomeCurrency.homeCurrencyIcon") as? String,
                let homeCurrencyNameRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "ChangeHomeCurrency.homeCurrencyName") as? String {
                
                UserDetails.ChangeHomeCurrency.homeCurrencyCode = homeCurrencyCodeRetrivel
                UserDetails.ChangeHomeCurrency.homeCurrencyIcon = homeCurrencyIconRetrivel
                UserDetails.ChangeHomeCurrency.homeCurrencyName = homeCurrencyNameRetrivel
                
            }
            
            if let nameRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "getAddtripeAttibutes.name") as? String,
                let iconRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "getAddtripeAttibutes.icon") as? String,
                let codeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "getAddtripeAttibutes.code") as? String {
                
                UserDetails.getAddtripeAttibutes.name = nameRetrivel
                UserDetails.getAddtripeAttibutes.icon = iconRetrivel
                UserDetails.getAddtripeAttibutes.code = codeRetrivel
                
            }
            
            if let CountryDelegateModelCodeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "CountryDelegateModel.code") as? String,
                let CountryDelegateModelIconRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "CountryDelegateModel.icon") as? String,
                let CountryDelegateModeidentifire = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "CountryDelegateModel.identifire") as? Int {
                
                UserDetails.CountryDelegateModel.code = CountryDelegateModelCodeRetrivel
                UserDetails.CountryDelegateModel.icon = CountryDelegateModelIconRetrivel
                UserDetails.CountryDelegateModel.identifire = CountryDelegateModeidentifire
                
            }
            
            if let CountryDelegateModelHomeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "CountryDelegateModel.Homeicon") as? String {
                UserDetails.CountryDelegateModel.Homeicon = CountryDelegateModelHomeRetrivel
            }
            
            if let CountryDelegateModelTargetRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "CountryDelegateModel.TargetIcon") as? String {
                UserDetails.CountryDelegateModel.TargetIcon = CountryDelegateModelTargetRetrivel
            }
            
            if let PercentageCalculationScannedAmountRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "PercentageCalculation.scannedAmount") as? String {
                UserDetails.PercentageCalculation.scannedAmount = PercentageCalculationScannedAmountRetrivel
            }
            
            if let PercentageCalculationConvertedAmountRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "PercentageCalculation.ConvertedAmount") as? String {
                UserDetails.PercentageCalculation.ConvertedAmount = PercentageCalculationConvertedAmountRetrivel
            }
            
            if let searchCountryFlagRetrievel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "searchCountryFlag") as? Bool {
                UserDetails.searchCountryFlag = searchCountryFlagRetrievel
            }
            
            if let getAddtripeAttibutesValueRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "getAddtripeAttibutes.value") as? String {
                UserDetails.getAddtripeAttibutes.value = getAddtripeAttibutesValueRetrivel
            }
            
            if let retriveData = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "HomeSreenUpdateValues") as? [String:[String]] {
                UserDetails.HomeSreenUpdateValues = retriveData
            }
            
            if let homeCodeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "haggleHomeCode") as? String {
                UserDetails.haggleHomeCode = homeCodeRetrivel
            }
            
            if let targetCodeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "haggleTargetCode") as? String {
                UserDetails.haggleTargetCode = targetCodeRetrivel
            }
            
            
            if let haggleHomeFlagRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "haggleHomeIcon") as? String {
                UserDetails.haggleHomeIcon = haggleHomeFlagRetrivel
            }
            
            if let haggleTargetFlagRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "haggleTargetIcon") as? String {
                UserDetails.haggleTargetIcon = haggleTargetFlagRetrivel
            }
            
            if let totalExpenseAdditionRetrive = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "totalExpenseAddition") as? [Int:[Double]] {
                UserDetails.totalExpenseAddition = totalExpenseAdditionRetrive
            }
            
        }else{
            
            if let retriveData = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "HomeSreenUpdateValues") as? [String:[String]] {
                UserDetails.HomeSreenUpdateValues = retriveData
            }
            
            if let addexpensiveRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "addExpensiveValue.code") as? String{
                UserDetails.addExpensiveValue.code = addexpensiveRetrivel
            }
            if let homeCurrencyCodeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "ChangeHomeCurrency.homeCurrencyCode") as? String,
                let homeCurrencyIconRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "ChangeHomeCurrency.homeCurrencyIcon") as? String,
                let homeCurrencyNameRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "ChangeHomeCurrency.homeCurrencyName") as? String {
                
                UserDetails.ChangeHomeCurrency.homeCurrencyCode = homeCurrencyCodeRetrivel
                UserDetails.ChangeHomeCurrency.homeCurrencyIcon = homeCurrencyIconRetrivel
                UserDetails.ChangeHomeCurrency.homeCurrencyName = homeCurrencyNameRetrivel
                
            }
            
            if let nameRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "getAddtripeAttibutes.name") as? String,
                let iconRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "getAddtripeAttibutes.icon") as? String,
                let codeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "getAddtripeAttibutes.code") as? String {
                
                UserDetails.getAddtripeAttibutes.name = nameRetrivel
                UserDetails.getAddtripeAttibutes.icon = iconRetrivel
                UserDetails.getAddtripeAttibutes.code = codeRetrivel
                
            }
            
            if let CountryDelegateModelCodeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "CountryDelegateModel.code") as? String,
                let CountryDelegateModelIconRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "CountryDelegateModel.icon") as? String {
                
                UserDetails.CountryDelegateModel.code = CountryDelegateModelCodeRetrivel
                UserDetails.CountryDelegateModel.icon = CountryDelegateModelIconRetrivel
                
            }
            
            if let CountryDelegateModelHomeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "CountryDelegateModel.Homeicon") as? String {
                UserDetails.CountryDelegateModel.Homeicon = CountryDelegateModelHomeRetrivel
            }
            if let CountryDelegateModelTargetRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "CountryDelegateModel.TargetIcon") as? String {
                UserDetails.CountryDelegateModel.TargetIcon = CountryDelegateModelTargetRetrivel
            }
            
            if let PercentageCalculationScannedAmountRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "PercentageCalculation.scannedAmount") as? String {
                UserDetails.PercentageCalculation.scannedAmount = PercentageCalculationScannedAmountRetrivel
            }
            if let PercentageCalculationConvertedAmountRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "PercentageCalculation.ConvertedAmount") as? String {
                UserDetails.PercentageCalculation.ConvertedAmount = PercentageCalculationConvertedAmountRetrivel
            }
            
            if let searchCountryFlagRetrievel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "searchCountryFlag") as? Bool {
                UserDetails.searchCountryFlag = searchCountryFlagRetrievel
            }
            
            if let homeCodeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "haggleHomeCode") as? String {
                UserDetails.haggleHomeCode = homeCodeRetrivel
            }
            
            if let targetCodeRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "haggleTargetCode") as? String {
                UserDetails.haggleTargetCode = targetCodeRetrivel
            }
            
            if let haggleHomeFlagRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "haggleHomeIcon") as? String {
                UserDetails.haggleHomeIcon = haggleHomeFlagRetrivel
            }
            
            if let haggleTargetFlagRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "haggleTargetIcon") as? String {
                UserDetails.haggleTargetIcon = haggleTargetFlagRetrivel
            }
        }
        
        //    if let idPal = StrongBoxController.sharedInstance.retriveUserDefaultValuesIDPalData(RetriveKey: "IDPalDocuments") as? [[String:UIImage]]  {
        //      IDPalUserData = idPal
        //    }
        
        if let idPal = UserDefaults.standard.value(forKey: "IDPalDocuments") as? [[String:Data]] {
            IDPalUserData = idPal
        }
        
        
        if let homeValues = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "HomeSreenUpdateValues") as? [String:[String]]{
            UserDetails.HomeSreenUpdateValues = homeValues
        }
        
        if let scanFlagRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "scannedCurrency.scannedCurrencyFlag") as? String {
            UserDetails.scannedCurrency.scannedCurrencyFlag = scanFlagRetrivel
        }
        
        if let delegateFlagRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "delegateFlag") as? Bool {
            UserDetails.delegateFlag = delegateFlagRetrivel
        }
        if let tripDatesRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "tripDate") as? [Int : Date] {
            UserDetails.tripDate = tripDatesRetrivel
        }
        if let tripEndDatesRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "tripEndDate") as? [Int : Date] {
            UserDetails.tripEndDate = tripEndDatesRetrivel
        }
        
        if let tripFlagRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "tripStartedFlag") as? Bool {
            UserDetails.tripStartedFlag = tripFlagRetrivel
        }
        
        if let validKeyRetrivel = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "validKey") as? Int {
            UserDetails.validKey = validKeyRetrivel
        }
        
        UserDetails.colorDataArray.removeAll()
        
        UserDetails.colorArray.forEach { (uicolorArray) in
            
            let data = NSKeyedArchiver.archivedData(withRootObject: uicolorArray[0])
            let data1 = NSKeyedArchiver.archivedData(withRootObject: uicolorArray[1])
            let updateValue = [data,data1]
            UserDetails.colorDataArray.append(updateValue)
        }
    }
}
