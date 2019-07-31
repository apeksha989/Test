//
//  DateValidation.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 05/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class DateValidation: NSObject {
  
  var dateFlag: Bool = false
  let dateFormatter = DateFormatter()
  let dateArray = [String]()
  
  private static var privateSharedInstance: DateValidation?
  static var sharedInstance: DateValidation {
    if privateSharedInstance == nil {
      privateSharedInstance = DateValidation()
    }
    return privateSharedInstance!
  }
  class func destroy() {
    privateSharedInstance = nil
  }
  
  func checkHomeScreenUpdates(Controller: UIViewController,currentDate: Date)-> Int? {
    print("CurrentDate --->",currentDate)
    dateFormatter.dateStyle = .short
    if !UserDetails.shared.tripArray.isEmpty{
      print("TripDate--->",UserDetails.tripDate)
      let startDates = UserDetails.tripDate.map {($0.value)}
      let endDates = UserDetails.tripEndDate.map {($0.value)}
      let dateKeys   = UserDetails.tripDate.map {($0.key)}
      print("DateKeys--->",dateKeys)
      let sortedDateKeys = dateKeys.sorted()
      print("sortedDateKeys--->",sortedDateKeys)
      let date = dateFormatter.string(from: currentDate)
      let format = dateFormatter.date(from: date)
      let value = format?.toLocalTime()
      print(value as Any)
      print(startDates)
      print(endDates)
      let startSorted =  startDates.sorted(by: { $0.compare($1) == .orderedAscending })
      let endSorted =  endDates.sorted(by: { $0.compare($1) == .orderedAscending })
      print("Sorted StartDate--->",startSorted)
      print("Sorted EndDate--->",endSorted)
      
      if UserDetails.tripDate.count == 1{
        if (endSorted[0] > value!) || (endSorted[0] == value!){
          UserDetails.validKey = sortedDateKeys[0]
          print("Valid Key--->",UserDetails.validKey)
          StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.validKey, storeType: "validKey")
          return UserDetails.validKey
        }else if (startSorted[0] > value!){
          UserDetails.validKey = sortedDateKeys[0]
          print("Valid Key--->",UserDetails.validKey)
          StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.validKey, storeType: "validKey")
          return UserDetails.validKey
        }else{
          return nil
        }
      }else{
        for i in 0..<(startSorted.count){
          if (startSorted[i] == value) || (startSorted[i] < value!){
            if (endSorted[i] == value) || (endSorted[i] > value!){
              UserDetails.validKey = sortedDateKeys[i]
              print("Valid Key--->",UserDetails.validKey)
              StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.validKey, storeType: "validKey")
              return UserDetails.validKey
            }else{
            }
          }else{
            if (startSorted[i] > value!){
              var keyArray: [Int] = []
              keyArray.append(sortedDateKeys[i])
              print("keyArray--->",keyArray)
              UserDetails.validKey = keyArray[0]
              print("Valid Key--->",UserDetails.validKey)
              StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.validKey, storeType: "validKey")
              return UserDetails.validKey
            }else{
            }
          }
        }
        return nil
      }
    }else{
      return nil
    }
  }
  
  func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
      return "\(components.year!) years ago"
    } else if (components.year! >= 1){
      if (numericDates){
        return "1 year ago"
      } else {
        return "Last year"
      }
    } else if (components.month! >= 2) {
      return "\(components.month!) months ago"
    } else if (components.month! >= 1){
      if (numericDates){
        return "1 month ago"
      } else {
        return "Last month"
      }
    } else if (components.weekOfYear! >= 2) {
      return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
      if (numericDates){
        return "1 week ago"
      } else {
        return "Last week"
      }
    } else if (components.day! >= 2) {
      return "\(components.day!) days ago"
    } else if (components.day! >= 1){
      if (numericDates){
        return "1 day ago"
      } else {
        return "Yesterday"
      }
    } else if (components.hour! >= 2) {
      return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
      if (numericDates){
        return "1 hour ago"
      } else {
        return "An hour ago"
      }
    } else if (components.minute! >= 2) {
      return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
      if (numericDates){
        return "1 minute ago"
      } else {
        return "A minute ago"
      }
    } else if (components.second! >= 3) {
      return "\(components.second!) seconds ago"
    } else {
      return "Just now"
    }
  }
}


