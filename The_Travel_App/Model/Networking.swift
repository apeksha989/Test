//
//  Networking.swift
//  Haggle
//
//  Created by Anil Kumar on 07/02/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


class Networking: NSObject {
  
  var countryNameWholeArray = [String]()
  var countryCodeWholeArray = [String]()
  var positionCurrencyCode  = Int()
  
  private static var privateSharedInstance: Networking?
  static var sharedInstance: Networking {
    if privateSharedInstance == nil {
      privateSharedInstance = Networking()
    }
    return privateSharedInstance!
  }
  class func destroy() {
    privateSharedInstance = nil
  }
  
  
  @objc func convertion(baseCurrency : String,targetCurrency: String,Value : String, completion:@escaping (_ success:Bool, _ error:String, _ result: String) -> Void) {
    
    Alamofire.request("\(APPURL.Domain)\(baseCurrency)&target=\(targetCurrency)&apikey=\(Key.CurrencyStack.Key)", method: .get, parameters: ["":""], encoding: URLEncoding.default).validate(statusCode: 200..<299).responseJSON(completionHandler: { response in
   
      if response.response?.statusCode == 500 {
         completion(false,"Error", "Selected currency not Available.")
      }
      switch response{
      case let response where response.error?._code == NSURLErrorTimedOut :
        completion(false,"URL Timed Out", "Please make sure internet connection!")
        
      case let response where (response.result.value != nil) :
        if let JSON = response.result.value as? Dictionary<String, AnyObject>{
          if let status = JSON["status"] as? Int ,(status == 200) {
            if let rates = JSON["rates"] as? NSDictionary, let getValue = rates.value(forKey: "\(targetCurrency)") as? Double{
              if let result     = Double(Value.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)) {
                let doubleStr = result * getValue
                let final     = String(format: "%.2f", doubleStr)
                completion(true,"", final)
              }
            }
          }
        }else{
          completion(false,"Error", "")
        }
      case let response where (response.result.value == nil) :
        completion(false, "Error", "")
        
      default:
        print("Default Value")
      }
    })
  }
  
  func requestForGetCountryCode(country : String, completionHandler: @escaping ( _ success: Bool,  _ result: String, _ error: String) -> Void){
    
    let bundle = Bundle(identifier: BudleIdentifire.Identifire)
    if let path = bundle!.path(forResource: "generated", ofType: "json") {
      do {
        let data  = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        if let jsonResult = jsonResult as? NSArray {
          
          let countryNameArray : NSArray = jsonResult.value(forKey: "country") as! NSArray
          let countryCodeArray : NSArray = jsonResult.value(forKey: "currency_code") as! NSArray
          
          countryNameArray.forEach { (countryName) in
            self.countryNameWholeArray.append(countryName as! String)
          }
          countryCodeArray.forEach { (countryCode) in
            self.countryCodeWholeArray.append(countryCode as! String)
          }
          (0..<(countryNameWholeArray.count)).forEach { (countryname) in
            if country == countryNameWholeArray[countryname]{
              positionCurrencyCode = countryname
            }
          }
          completionHandler(true, countryCodeWholeArray[positionCurrencyCode], "")
        }
      } catch {
        completionHandler(false, "", "error")
      }
    }
  }
  
  func getCountryFlags(completion: (([DataModelItem]?, NSError?) -> Void)?){
    
    if let path = Bundle.main.url(forResource: "countries", withExtension: "json") {
      let data = try! Data(contentsOf: path)
      let cars = try! JSONDecoder().decode([DataModelItem].self, from: data)
      completion!(cars,nil)
    }
  }
  
  func proccessImage(_ imageURL:String,profileName: String){
    Alamofire.request(imageURL, method: .get).responseData { response in
      guard let imageData = response.result.value else {
        return
      }
      _ = StrongBoxController.sharedInstance.Archiev(imageData: imageData, name: profileName)
    }
  }
}


