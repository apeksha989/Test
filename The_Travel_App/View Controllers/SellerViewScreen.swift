//
//  SellerViewScreen.swift
//  Haggle
//
//  Created by Anil Kumar on 16/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class SellerViewScreen: UIViewController {
    
    private let sellerViewBG   = UIImageFactory()
      .setImage(imageString: "Seller_View_BG")
    .build()

    private let sellerAmount   = UILabelFactory(text: "€150.00")
      .textFonts(with: UIFont(name: "Montserrat-Medium", size: 66)!)
      .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
    private let closeButton    = UIButtonFactory(title: "")
      .addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    .build()
  
    private let addToWallet    = UIButtonFactory(title: "")
      .addTarget(self, action: #selector(addToWalletTapped), for: .touchUpInside)
   .build()
    
    var currrentDate  = Date()
    var startDate     = [Date]()
    var limitedDates: [Date] = []
  var dateFormatter = DateFormatter()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("<---------SellerViewScreen------------>😀")
        setUpLayoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !UserDetails.AddToWalletScannedAmount.isEmpty{
            sellerAmount.text = UserDetails.AddToWalletScannedAmount
            addToWallet.isUserInteractionEnabled = true
        }else{
            sellerAmount.text = "0"
            addToWallet.isUserInteractionEnabled = false
        }
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 19)
        
        addToWallet.setTitle("Add To Wallet", for: .normal)
        addToWallet.setTitleColor(UIColor.white, for: .normal)
        addToWallet.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 19)
        
    }
    
    func setUpLayoutViews(){
        view.addSubview(sellerViewBG)
        sellerViewBG.addSubview(sellerAmount)
        view.addSubview(closeButton)
        view.addSubview(addToWallet)
        
        sellerViewBG.bringSubviewToFront(sellerAmount)
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(addToWallet)
        
        setUpConstraintsToAttributes()
    }
    
    @objc func addToWalletTapped() {
      dateFormatter.dateStyle = .short
      let startDate = dateFormatter.string(from: currrentDate)
      let startDateformat = dateFormatter.date(from: startDate)
      let currrentDateValue = startDateformat?.toLocalTime()
      
        if UserDetails.shared.tripArray.isEmpty {
            showConfirmAlert(title: "Warning", message: "You have not created any trip yet", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
        }else{
            UserDetails.AddToWallet.WalletBackClicked = false
            UserDetails.AddToWallet.WalletClicked = false
            limitedDates.removeAll()
            let keys = UserDetails.tripDate.map {($0.value)}
            
            for i in keys{
              if !i.isGreaterThan(currrentDateValue!){
                    if i.isEqualTo(currrentDateValue!) || i.isSmallerThan(currrentDateValue!){
                        limitedDates.append(i)
                    }
                }
            }
            let sorted =  limitedDates.map{ ( ($0 < Date() ? 1 : 0), $0) }.sorted(by:<).map{$1}
            print(sorted)
          
          if sorted.isEmpty{
            showConfirmAlert(title: "", message: "Trips available only for future date!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
            return
          }
            let selectedDate = sorted.last
            print(selectedDate as Any)
            print(UserDetails.tripDate)
            if let selectedKey = UserDetails.tripDate.someKey(forValue: (selectedDate!)){
                print(selectedKey)
                UserDetails.budgetID = selectedKey
            }
            UserDetails.AddToWallet.ConfirmClicked = false
            popOrPushToViewController("AddExpenseController")
        }
    }
    
    @objc func closeButtonTapped(){
        navigationController?.popViewController(animated: true)
        popOrPushToViewController("HaggleMainScreen")
    }
    
    func setUpConstraintsToAttributes(){
        
        sellerViewBG.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        sellerAmount.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: sellerViewBG.centerXAnchor, centerY: sellerViewBG.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 84.0, enableInsets: true)
        
        closeButton.layoutAnchor(top: nil, left: sellerViewBG.leftAnchor, bottom: sellerViewBG.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 38.0, paddingBottom: 24.0, paddingRight: 0.0, width: 55.0, height: 22.0, enableInsets: true)
        
        addToWallet.layoutAnchor(top: nil, left: nil, bottom: sellerViewBG.bottomAnchor, right: sellerViewBG.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 24.0, paddingRight: 23.0, width: 140.0, height: 23.0, enableInsets: true)
    }
}

extension Date {
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
