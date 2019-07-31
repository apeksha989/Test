//
//  NotificationController.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 18/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationController {
  
  private static var privateShared: NotificationController?
  
  static var shared: NotificationController {
    if privateShared == nil {
      privateShared = NotificationController()
    }
    return privateShared!
  }
  class func destroy() {
    privateShared = nil
  }
  
  private let notificationCenter = UNUserNotificationCenter.current()
  
  func registerLocalNotification(){
    
    let appDelegateSharing = UIApplication.shared.delegate as? AppDelegate
      
    notificationCenter.delegate = appDelegateSharing
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    notificationCenter.requestAuthorization(options: options) {
      (didAllow, error) in
      if !didAllow {
        if let controller = appDelegateSharing?.currentViewController(){
          controller.showConfirmAlert(title: "", message: "User has declined notifications", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
          print("User has declined notifications")
        }
      }
    }
  }
  
  func scheduleNotification(notificatioTitle: String,notificationMessage: String, identifier:String) {
    print(identifier)
    let content = UNMutableNotificationContent()
    let categoryIdentifire = "Delete Notification Type"
    
    content.title = notificatioTitle
    content.body =  notificationMessage
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = categoryIdentifire
    
    var imageName = ""
    if identifier == "Budget Alert" {
      imageName = "Budget_Alert"
    }else{
      imageName = "Expense_Alert"
    }
    guard let bundle = Bundle(identifier: BudleIdentifire.Identifire) else { return }
    guard let imageURL = bundle.url(forResource: imageName, withExtension: "png") else {
      return
    }
    let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
    content.attachments = [attachment]
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
    let identifier = identifier
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    notificationCenter.add(request) { (error) in
      if let error = error {
        print("Error \(error.localizedDescription)")
      }
    }
    
    let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
    let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
    let category = UNNotificationCategory(identifier: categoryIdentifire,
                                          actions: [snoozeAction, deleteAction],
                                          intentIdentifiers: [],
                                          options: [])
    
    notificationCenter.setNotificationCategories([category])
  }
}
