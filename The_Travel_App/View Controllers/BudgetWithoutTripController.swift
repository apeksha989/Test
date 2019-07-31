//
//  BudgetWithoutTripController.swift
//  Haggle
//
//  Created by Anil Kumar on 17/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class BudgetWithoutTripController: UIViewController {
  
  private let budgetNavigationView = UIViewFactory()
  .build()
  
  private let budgetTitle = UILabelFactory(text: "Budget")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  private let budgetBackButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Black_Back_Btn")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
  .build()
  
  private let emptyTripLabel = UILabelFactory(text: "You have not created a trip yet. Please begin by clicking below.")
    .setAlpha(value: 0.52)
    .numberOf(lines: 0)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 29)!)
    .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
    .textAlignment(with: .center)
  .build()
  
  private let createTripButton = UIButtonFactory(title: "CREATE TRIP")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .setTitileColour(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .addTarget(self, action: #selector(createTripButtonTapped), for: .touchUpInside)
  .build()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      debugPrint("<---------BudgetWithoutTripController------------>😀")
        setUpLayoutViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradiantViewButton(createTripButton)
        
        createTripButton.setTitle("CREATE TRIP", for: .normal)
        createTripButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 14)
        createTripButton.setTitleColor(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1), for: .normal)
    }
    
    @objc func backButtonTapped(){
      popOrPushToViewController("WalletMainController")        
    }
    
    @objc func createTripButtonTapped(){
        popOrPushToViewController("AddTripController")
    }
    
    func setUpLayoutViews(){
        view.addSubview(budgetNavigationView)
        budgetNavigationView.addSubview(budgetTitle)
        budgetNavigationView.addSubview(budgetBackButton)
        view.addSubview(emptyTripLabel)
        view.addSubview(createTripButton)
        
        
        budgetNavigationView.bringSubviewToFront(budgetTitle)
        budgetNavigationView.bringSubviewToFront(budgetBackButton)
        view.bringSubviewToFront(emptyTripLabel)
        view.bringSubviewToFront(createTripButton)
        
        setUpConstraintsToAttributes()
    }
    
    func setUpConstraintsToAttributes(){
        
        switch UIDevice().type {
        case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
            budgetNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)
            
            createTripButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 85.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
        default:
            budgetNavigationView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
            
            createTripButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 65.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
        }
        
        budgetTitle.layoutAnchor(top: nil, left: nil, bottom: budgetNavigationView.bottomAnchor, right: nil, centerX: budgetNavigationView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 21.0, enableInsets: true)
        
        budgetBackButton.layoutAnchor(top: nil, left: budgetNavigationView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: budgetTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        
        emptyTripLabel.layoutAnchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0.0, paddingLeft: 27.0, paddingBottom: 0.0, paddingRight: 28.0, width: 0.0, height: 330, enableInsets: true)
    }
}
