//
//  ImageVault.swift
//  Haggle
//
//  Created by Anil Kumar on 02/05/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import Strongbox

class StrongBoxController{
  
  private var store = Strongbox()
  private var tempOptional : UIImage?
  
  private static var privateSharedInstance: StrongBoxController?
  
  static var sharedInstance: StrongBoxController {
    if privateSharedInstance == nil {
      privateSharedInstance = StrongBoxController()
    }
    return privateSharedInstance!
  }
  class func destroy() {
    privateSharedInstance = nil
  }
  
  func Archiev(imageData: Data,name: String) -> Bool{
    _ = store.archive(imageData, key: "Social_image_Key")
    _ = store.archive(name, key: "Social_Name_Key")
    return true
  }
  
  func imageUnArcheive()-> UIImage?{
    if let unArchive_Data = store.unarchive(objectForKey: "Social_image_Key") as? Data {
      let unArchive_Image = UIImage(data: unArchive_Data)
      return unArchive_Image
    }else {
      return tempOptional
    }
  }
  
  func nameUnArcheive() -> String {
    let unArchive_Name = store.unarchive(objectForKey: "Social_Name_Key") as? String
    if unArchive_Name != nil{
      return unArchive_Name!
    }else{
      return ""
    }
  }
  
  func storeUserDefault(data: Any?,storeType: String){
    _ = store.archive(data, key: storeType)
  }
  
  func retriveUserDefaultValues(RetriveKey: String) -> Any? {
    let value = store.unarchive(objectForKey: RetriveKey)
    if value != nil {
      return value
    }
    return nil
  }   
  
  func storeExpandableArray(array:[Int : UserDetails.ExpandableNames], storeType: String){
    _ = store.archive(try? PropertyListEncoder().encode(array), key: storeType)
  }
  
  func retriveExpandableArray(RetriveKey:String)-> [Int:UserDetails.ExpandableNames]?{
    if let value = store.unarchive(objectForKey: RetriveKey) as? Data {
      let updatedCategoryRetrive = try? PropertyListDecoder().decode([Int:UserDetails.ExpandableNames].self, from: value)
      return updatedCategoryRetrive!
    }else{
      return nil
    }
  }
  
  func removeUserDefaultValues(RetriveKey: String) {
    store.remove(key: RetriveKey)
  }
  
  func removeValuesFromStrongBox(){
    store.remove(key: "Social_image_Key")
    store.remove(key: "Social_Name_Key")
    store.remove(key: "LocationName")
    store.remove(key: "LocationCode")
    store.remove(key: "countryAndCodeAndIcon")
    store.remove(key: "HomeSreenUpdateValues")
    store.remove(key: "haggleHomeIcon")
    store.remove(key: "haggleTargetCode")
    store.remove(key: "scannedCurrency.scannedCurrencyFlag")
    store.remove(key: "haggleHomeCode")
    store.remove(key: "haggleTargetIcon")
    store.remove(key: "getAddtripeAttibutes.value")
    store.remove(key: "tripArrayStore")
    store.remove(key: "tripDate")
    store.remove(key: "tripEndDate")
    store.remove(key: "creatCategoryArray1")
    store.remove(key: "tripId")
    store.remove(key: "getAddtripeAttibutes.name")
    store.remove(key: "getAddtripeAttibutes.icon")
    store.remove(key: "getAddtripeAttibutes.code")
    store.remove(key: "totalExpenseAddition")
    store.remove(key: "dict1")
    store.remove(key: "totalAmount")
    store.remove(key: "totalExpenseAddition")
    store.remove(key: "WalletDocImageArray")
    store.remove(key: "WalletDocDateArray")
    store.remove(key: "PercentageCalculation.scannedAmount")
    store.remove(key: "PercentageCalculation.ConvertedAmount")
    store.remove(key: "ChangeHomeCurrency.homeCurrencyCode")
    store.remove(key: "ChangeHomeCurrency.homeCurrencyIcon")
    store.remove(key: "ChangeHomeCurrency.homeCurrencyName")
    store.remove(key: "delegateFlag")
    store.remove(key: "CountryDelegateModel.code")
    store.remove(key: "CountryDelegateModel.icon")
    store.remove(key: "addExpensiveValue.code")
    store.remove(key: "tripStartedFlag")
    store.remove(key: "geticon")
    store.remove(key: "categoryWholeArray")
    store.remove(key: "HomePage")
    store.remove(key: "HomePagePopUp")
    store.remove(key: "searchCountryFlag")
    store.remove(key: "colorArrayRandomPicker")
    store.remove(key: "notificationArray")
    store.remove(key: "IDPalDocuments")
  } 
}
