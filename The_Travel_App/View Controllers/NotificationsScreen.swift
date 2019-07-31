//
//  NotificationsScreen.swift
//  haggleDemo
//
//  Created by Anil Kumar on 01/04/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit

class NotificationsScreen: UIViewController {
    
    let notificationBar = UIViewFactory()
        .build()
    
    lazy var notificationTable : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    let notificationTitle = UILabelFactory(text: "Notifications")
        .textAlignment(with: .center)
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
        .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
        .build()
    
    
    let backButton = UIButtonFactory(title: "")
        .setBackgroundImage(image: "BackBtn")
        .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        .setTintColor(color: UIColor.white)
        .build()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("<---------NotificationsScreen------------>😀")
        setUpAutoLayoutView()
        
        notificationTable.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        notificationTable.dataSource = self
        notificationTable.delegate = self
        notificationTable.showsVerticalScrollIndicator = false
        notificationTable.showsHorizontalScrollIndicator = false
        notificationTable.tableFooterView = UIView()
        
        print(UserDetails.shared.notificationArray)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradiantView(notificationBar, self)
    }
    
    deinit {
        notificationTable.delegate = nil
        
        print("Deinitilization NotificationCntroller--->" , NotificationsScreen.self)
    }
    
    
    func setUpAutoLayoutView(){
        view.addSubview(notificationBar)
        notificationBar.addSubview(notificationTitle)
        notificationBar.addSubview(backButton)
        view.addSubview(notificationTable)
        
        notificationBar.bringSubviewToFront(notificationTitle)
        notificationBar.bringSubviewToFront(backButton)
        view.bringSubviewToFront(notificationTable)
        
        setUpConstraintsToAttributes()
        
    }
    
    func setUpConstraintsToAttributes() {
        switch UIDevice().type {
        case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
            
            notificationBar.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 102.0, enableInsets: true)
            
            notificationTitle.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: notificationBar.centerXAnchor, centerY: notificationBar.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
            
            backButton.layoutAnchor(top: nil, left: notificationBar.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: notificationTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        default:
            notificationBar.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 82.0, enableInsets: true)
            
            notificationTitle.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: notificationBar.centerXAnchor, centerY: notificationBar.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
            
            backButton.layoutAnchor(top: nil, left: notificationBar.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: notificationTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        }
        notificationTable.layoutAnchor(top: notificationBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 30.0, paddingBottom: 0.0, paddingRight: 30.0, width: 0.0, height: 0.0, enableInsets: true)
        
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
}

extension NotificationsScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (UserDetails.shared.notificationArray.isEmpty) || (UserDetails.shared.notificationArray.count == 0) {
            tableView.setEmptyMessage("No Notifications available")
            return 0
        }else{
            return UserDetails.shared.notificationArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.selectionStyle = .none
        
        let budgetArray = UserDetails.shared.notificationArray[indexPath.row]
        
        if budgetArray[0] == "Budget Alert"{
            cell.notificationIcon.image = UIImage(named: "Budget_Icon")
        }else{
            cell.notificationIcon.image = UIImage(named: "Expense_Icon")
        }
        
        let stringDate = budgetArray[2]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:stringDate)!
        print(date)
        
        let timeAgo:String = DateValidation.sharedInstance.timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        print(timeAgo)
        
        cell.notiificationTitle.text = budgetArray[0]
        cell.notificationDetail.text = budgetArray[1]
        cell.notificationDays.text = timeAgo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

