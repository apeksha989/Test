//
//  HomeScreenUpdateModel.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 05/07/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation


class HomeScreenUpdate {
  
  
  private static var privateSharedInstance: HomeScreenUpdate?
  
  static var shared: HomeScreenUpdate {
    if privateSharedInstance == nil {
      privateSharedInstance = HomeScreenUpdate()
    }
    return privateSharedInstance!
  }
  class func destroy() {
    privateSharedInstance = nil
  }
  
  func updateHomeScreen(_ controller: UIViewController, _ currentDate: Date){
    if let key = DateValidation.sharedInstance.checkHomeScreenUpdates(Controller: controller, currentDate: currentDate) {
      let TotBudget = UserDetails.shared.tripArray[key]?["totelBudjet"] as? String
      let getCode = UserDetails.shared.tripArray[key]?["code"] as? String
      let numberOnly = controller.matches(for: RegExpression.shared.NumberRegex, in: TotBudget!)
      if UserDetails.ChangeHomeCurrency.homeCurrencyCode.isEmpty {
        let countryCode = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "LocationCode")as? String
        convertionUpdateToHomeScreen(controller, BaseCode: getCode!, targetCode: countryCode!, amount: numberOnly.joined(),TotalBudget: TotBudget!)
      }else{
        convertionUpdateToHomeScreen(controller, BaseCode: getCode!, targetCode: UserDetails.ChangeHomeCurrency.homeCurrencyCode, amount: numberOnly.joined(),TotalBudget: TotBudget!)
      }
    }else{
      let UpdateValues = ["0.00","0.00"]
      UserDetails.HomeSreenUpdateValues.updateValue(UpdateValues, forKey: "WalletUpdate")
      StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
    }
    NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
  }
  
  func convertionUpdateToHomeScreen(_ controller: UIViewController, BaseCode:String, targetCode:String, amount:String, TotalBudget: String){
    debugPrint("<---------Convertion Sending NetWork Request From AddTripController Please Wait------------>😺")
    var Amount = ""
    Networking.sharedInstance.convertion(baseCurrency: BaseCode, targetCurrency: targetCode, Value: amount) { (success, error, result) in
      if success {
        debugPrint("<---------Convertion Success------------>😄")
        let finalvalue = controller.matches(for: RegExpression.shared.NumberRegex, in: result)
        let tripCode = controller.matches(for: RegExpression.shared.CodesRegex, in: TotalBudget)
        let final = finalvalue[0].replacingOccurrences(of: ".", with: "")
        Amount = final
        let UpdateValues = [amount+" "+tripCode.joined(),Amount+" "+targetCode]
        UserDetails.HomeSreenUpdateValues.updateValue(UpdateValues, forKey: "WalletUpdate")
        StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.HomeSreenUpdateValues, storeType: "HomeSreenUpdateValues")
        NotificationCenter.default.post(name: .UpdatedHomeScreenValues, object: nil)
      }else{
        debugPrint("<---------Failed Convertion------------>")
        if let controller = controller as? AddTripController {
          controller.addTripBackButton.isUserInteractionEnabled = true
          controller.confirmButton.isUserInteractionEnabled = true
          controller.confirmButton.loadingIndicator(show: false)
          controller.confirmButton.setTitle("CONFIRM", for: .normal)
          controller.showConfirmAlert(title: "", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: { (action) in
          })
        }else{
//          controller.showConfirmAlert(title: "", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: { (action) in
//          })
        }
      }
    }
  }
  
}
