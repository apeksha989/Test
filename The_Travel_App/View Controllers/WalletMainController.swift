//
//  WalletMainController.swift
//  Haggle
//
//  Created by Anil Kumar on 19/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class WalletMainController: UIViewController {
  
  lazy var walletTable : UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  let walletTopView    = UIViewFactory()
  .build()
  
  let walletBackBtn = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Black_Back_Btn")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
  .build()
  
  let walletTitle = UILabelFactory(text: "Wallet")
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textAlignment(with: .center)
  .build()
  
  var walletImages          = ["Wallet_Budget_Icon", "Id_Icon", "Document_Icon"]
  var walletMenu            = ["Budget", "ID", "Documents"]
  var walletDetail          = ["Track your finances as you travel, create alerts to stay on top of your spending", "Store verified copies of your vital identification documents", "Save your ID documents, travel documents including tickets, itineraries and other essentials."]
  
  let value = RegExpression.shared.codeToSymbole.map {($0.value)}
  let symboleGetArray = RegExpression.shared.codeToSymbole.map {($0.key)}
  
    override func viewDidLoad() {
        super.viewDidLoad()
      debugPrint("<---------WalletMainController------------>😀")
        walletTable.delegate = self
        walletTable.dataSource = self
        walletTable.tableFooterView = UIView()
        walletTable.separatorStyle = .none
        walletTable.showsVerticalScrollIndicator = false
      
        setUpCellRegistration()
        setUpLayoutViews()
    }
  override func viewWillAppear(_ animated: Bool) {
    walletTable.reloadData()
    NotificationCenter.default.addObserver(self, selector: #selector(updatingValues), name: .UpdatedHomeScreenValues, object: nil)
  }
  @objc func updatingValues(){
    let indexPath = IndexPath(row: 0, section: 0)
    walletTable.reloadRows(at: [indexPath], with: .automatic)
  }
  
  deinit {
    walletImages.removeAll()
    walletMenu.removeAll()
    walletDetail.removeAll()
    walletTable.delegate = nil
    print("Deinitlization WalletMainController--->",WalletMainController.self)
  }
  
  @objc func updateValues(){
    
  }
    @objc func backButtonTapped(){
        NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func setUpLayoutViews(){
        view.addSubview(walletTopView)
        walletTopView.addSubview(walletTitle)
        walletTopView.addSubview(walletBackBtn)
        view.addSubview(walletTable)
        
        walletTopView.bringSubviewToFront(walletTitle)
        walletTopView.bringSubviewToFront(walletBackBtn)
        
        setUpConstraintsToAttributes()
    }
    
    func setUpCellRegistration(){
        walletTable.register(WalletMainViewCell.self, forCellReuseIdentifier: "WalletMainViewCell")
    }

  func setUpConstraintsToAttributes(){
        switch UIDevice().type {
        case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
            walletTopView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)
        default:
            walletTopView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
        }
        walletTitle.layoutAnchor(top: nil, left: nil, bottom: walletTopView.bottomAnchor, right: nil, centerX: walletTopView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
        
        walletBackBtn.layoutAnchor(top: nil, left: walletTopView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: walletTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        
        walletTable.layoutAnchor(top: walletTopView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 60.0, paddingLeft: 8.0, paddingBottom: 0.0, paddingRight: 8.0, width: 0.0, height: 0.0, enableInsets: true)
    }
}

extension WalletMainController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0{       
      if !UserDetails.shared.tripArray.isEmpty{
        popOrPushToViewController("AllTripsController")
      }else{
        popOrPushToViewController("BudgetWithoutTripController")
      }
    }else if indexPath.row == 1{
      popOrPushToViewController("WalletIdController")
    }else{
      popOrPushToViewController("CameraController")
    }
  }
}

extension WalletMainController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      var cell = tableView.dequeueReusableCell(withIdentifier: "WalletMainViewCell", for: indexPath) as? WalletMainViewCell
      
      if cell == nil {
        cell = WalletMainViewCell.init(style: .default, reuseIdentifier: "WalletMainViewCell")
      }
      
      cell?.walletMenu.image      = UIImage(named: walletImages[indexPath.row])
      cell?.walletTitle.text      = walletMenu[indexPath.row]
      cell?.walletItemDetail.text = walletDetail[indexPath.row]
      if indexPath.row == 0{
        cell?.totalBudgetLabel.text   = "Total Budget"
        cell?.homeCurrency.text       = "Home Currency"
        if !UserDetails.shared.tripArray.isEmpty {
          let values =  UserDetails.HomeSreenUpdateValues["WalletUpdate"]
          let topRegExCode = self.matches(for: RegExpression.shared.CodesRegex, in: values![0])
          let bottomRegExCode = self.matches(for: RegExpression.shared.CodesRegex, in: values![1])
          
          let topRegExValues = self.matches(for: RegExpression.shared.NumberRegex, in: values![0])
          let bottomRegExValues = self.matches(for: RegExpression.shared.NumberRegex, in: values![1])
          
          var topSymbol = getSymbolForCurrencyCode(code: topRegExCode.joined())
          var BottomSymbol = getSymbolForCurrencyCode(code: bottomRegExCode.joined())
          
          let topIndex = symboleGetArray.firstIndex { (str) -> Bool in
            str == topRegExCode.joined()
          }
          
          if let topInt = topIndex {
            topSymbol = value[topInt]
          }
          
          let bottomIndex = symboleGetArray.firstIndex { (strValue) -> Bool in
            strValue == bottomRegExCode.joined()
          }
        
          if let BottomInt = bottomIndex {
            BottomSymbol = value[BottomInt]
          }
        
          let topValue = topRegExValues.joined()
          let BottomValue = bottomRegExValues.joined()
                    
          cell?.totalBudgetAmount.text = "\(topSymbol) \(topValue)"
          cell?.homeCurrencyAmount.text = "\(BottomSymbol) \(BottomValue)"

        }else{
          cell?.totalBudgetAmount.text  = "0.00"
          cell?.homeCurrencyAmount.text = "0.00"
        }
      }
      cell?.selectionStyle = .none
      return cell!
  }
}

