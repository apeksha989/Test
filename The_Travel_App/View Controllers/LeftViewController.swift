//
//  LeftViewController.swift
//  haggleDemo
//
//  Created by Anil Kumar on 01/04/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {
    
    var HomeScreen : UIViewController!
    var menuLabel = ["Register Account", "Notifications", "Help", "Privacy Policy/T&C", "Change Home Currency"]
    var menuIcon = ["MyAccount_Icon", "Notification_Icon", "Help_Icon", "Privacy_Icon", "AppSettings_Icon"]
    
    let profileContainerView = UIViewFactory()
        .build()
    
    lazy var menuTable : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    let profileName = UILabelFactory(text: "")
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 15)!)
        .numberOf(lines: 4)
        .textAlignment(with: .left)
        .textColor(with: hexStringToUIColor(hex: "#2C82BE"))
        .build()
    
    let profileIcon = UIImageFactory()
        .build()
    
    let deleteButton = UIButtonFactory(title: "")
        .setBackgroundImage(image: "Close")
        .addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        .build()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      debugPrint("<---------LeftViewController------------>😀")
        navigationController?.navigationBar.isHidden = true
        setUpLayoutView()
        
        profileName.text =  StrongBoxController.sharedInstance.nameUnArcheive() != "" ? "\(StrongBoxController.sharedInstance.nameUnArcheive())" : "To fully enjoy The Travel App, please register for an account below"
        if let image = StrongBoxController.sharedInstance.imageUnArcheive(){
            profileIcon.image = image
            menuLabel.remove(at: 0)
            menuIcon.remove(at: 0)
        }else{
            profileIcon.image = getImageFromBundleClass.getImageFromBundle("profileIcon")
        }
        
        menuTable.register(TableMenuViewCell.self, forCellReuseIdentifier: "cell")
        menuTable.dataSource = self
        menuTable.delegate = self
        menuTable.tableFooterView = UIView()
        menuTable.separatorStyle = .none
        menuTable.allowsSelection = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileContainerView.layer.cornerRadius = profileContainerView.frame.size.height/2
        profileContainerView.layer.shadowColor = UIColor(red: 0.12, green: 0.03, blue: 0.27, alpha: 0.20).cgColor
        profileContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        profileContainerView.layer.shadowOpacity = 0.2
        
        profileIcon.layer.cornerRadius = profileIcon.frame.size.height/2
        profileIcon.clipsToBounds = true
    }
    
    func setUpLayoutView(){
        view.addSubview(deleteButton)
        view.addSubview(profileContainerView)
        profileContainerView.addSubview(profileIcon)
        view.addSubview(profileName)
        view.addSubview(menuTable)
        
        bringSubView(button: deleteButton)
        profileContainerView.bringSubviewToFront(profileIcon)
        view.bringSubviewToFront(profileName)
        view.bringSubviewToFront(menuTable)
        
        setUpLayoutConstraintsToAttributes()
    }
  
  deinit {
    menuTable.delegate = nil
    print("Deinitilization LeftViewController---->",LeftViewController.self)
  }
  
    @objc func deleteButtonTapped() {
        slideMenuController()?.closeLeft1()
    }
    
    func setUpLayoutConstraintsToAttributes() {
        deleteButton.layoutAnchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: view.frame.size.height/16.2, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 25.0, width: 16.0, height: 16.0, enableInsets: true)
        
        profileContainerView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: view.frame.size.height/11.9, paddingLeft: 35.0, paddingBottom: 0.0, paddingRight: 0.0, width: 57.0, height: 57.0, enableInsets: true)
        
        profileIcon.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: view.frame.size.height/11.9, paddingLeft: 35.0, paddingBottom: 0.0, paddingRight: 0.0, width: 57.0, height: 57.0, enableInsets: true)
        
        profileName.layoutAnchor(top: nil, left: profileIcon.rightAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: profileIcon.centerYAnchor, paddingTop: 0.0, paddingLeft: 25.0, paddingBottom: 0.0, paddingRight: 25.0, width: 0.0, height: 0.0, enableInsets: true)
        
        menuTable.layoutAnchor(top: profileIcon.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 50.0, paddingLeft: 40.0, paddingBottom: 0.0, paddingRight: 40.0, width: 0.0, height: 0.0, enableInsets: true)
    }
}

extension LeftViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuIcon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableMenuViewCell
        cell.menuIcon.image = getImageFromBundleClass.getImageFromBundle(menuIcon[indexPath.row])
        cell.menuName.text = menuLabel[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if StrongBoxController.sharedInstance.imageUnArcheive() != nil{
            if indexPath.row == 0{
                popOrPushToViewController("NotificationsScreen")
            }else if indexPath.row == 3{
                slideMenuController()?.closeLeft1()
                UserDetails.ChangeHomeCurrency.homeCurrency = false
                presentDissmiss(controller: "CountryViewController")
            }else if indexPath.row == 1{
                UserDetails.privacyFlag = false
                popOrPushToViewController("PrivacyPolicy_HelpController")
            }else if indexPath.row == 2{
                UserDetails.privacyFlag = true
                popOrPushToViewController("PrivacyPolicy_HelpController")
            }
        }else{
            if indexPath.row == 0{
                StrongBoxController.sharedInstance.storeUserDefault(data: nil, storeType: "HomePage")
                //                defualt.set(nil , forKey: "HomePage")
                UserDetails.locationProperties.shared.countryCode = ""
                rootController()
            }else if indexPath.row == 1{
                popOrPushToViewController("NotificationsScreen")
            }else if indexPath.row == 4{
                slideMenuController()?.closeLeft1()
                UserDetails.ChangeHomeCurrency.homeCurrency = false
                presentDissmiss(controller: "CountryViewController")
            }else if indexPath.row == 2{
                UserDetails.privacyFlag = false
                popOrPushToViewController("PrivacyPolicy_HelpController")
            }else if indexPath.row == 3{
                UserDetails.privacyFlag = true
                popOrPushToViewController("PrivacyPolicy_HelpController")
            }
        }
    }
    
    func rootController(){
        let homeNavigationController = UINavigationController(rootViewController: SocialMediaViewController())
        homeNavigationController.setNavigationBarHidden(true, animated: false)
        let appDelegate = UIApplication.shared.delegate
        appDelegate!.window?!.rootViewController = homeNavigationController
        appDelegate!.window?!.makeKeyAndVisible()
    }
}

