//
//  convertionHomeScreen.swift
//  Haggle
//
//  Created by Anil Kumar on 30/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation

class HomeScreenMode{
if !getAddtripeAttibutes.name.isEmpty && !PercentageCalculation.ConvertedAmount.isEmpty,!PercentageCalculation.scannedAmount.isEmpty {
  if !(UpdateHomeScreenValued.topValues.count == 0){
    UpdateHomeScreenValued.topValues.removeAllObjects()
    UpdateHomeScreenValued.bottomValues.removeAllObjects()
    
    Networking.sharedInstance.convertion(baseCurrency: getAddtripeAttibutes.code, targetCurrency: locationProperties.shared.countryCode!, Value: getAddtripeAttibutes.value) { (success, error, result) in
      if success {
        let baseSymbole = self.getSymbolForCurrencyCode(code: "\(getAddtripeAttibutes.code)")
        let targetSymbole = self.getSymbolForCurrencyCode(code: "\(locationProperties.shared.countryCode!)")
        UpdateHomeScreenValued.topValues.addObjects(from: [baseSymbole + getAddtripeAttibutes.value,PercentageCalculation.scannedAmount,PercentageCalculation.scannedAmount])
        UpdateHomeScreenValued.bottomValues.addObjects(from: [targetSymbole + result,PercentageCalculation.ConvertedAmount,PercentageCalculation.ConvertedAmount])
      }else{
        self.showConfirmAlert(title: "error", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
      }
    }
  }
} else if !getAddtripeAttibutes.name.isEmpty && PercentageCalculation.ConvertedAmount.isEmpty,PercentageCalculation.scannedAmount.isEmpty{
  UpdateHomeScreenValued.topValues.removeAllObjects()
  UpdateHomeScreenValued.bottomValues.removeAllObjects()
  Networking.sharedInstance.convertion(baseCurrency: getAddtripeAttibutes.code, targetCurrency: locationProperties.shared.countryCode!, Value: getAddtripeAttibutes.value) { (success, error, result) in
    if success {
      let baseSymbole = self.getSymbolForCurrencyCode(code: "\(getAddtripeAttibutes.code)")
      let targetSymbole = self.getSymbolForCurrencyCode(code: "\(locationProperties.shared.countryCode!)")
      UpdateHomeScreenValued.topValues.addObjects(from: [baseSymbole + getAddtripeAttibutes.value,"0 \(locationProperties.shared.countryCode!)","0 \(locationProperties.shared.countryCode!)"])
      UpdateHomeScreenValued.bottomValues.addObjects(from: [targetSymbole + result,"0.00 AUD","0.00 AUD"])
    }else{
      self.showConfirmAlert(title: "error", message: error, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
    }
  }
}else if getAddtripeAttibutes.name.isEmpty && !PercentageCalculation.ConvertedAmount.isEmpty,!PercentageCalculation.scannedAmount.isEmpty{
  if !(UpdateHomeScreenValued.topValues.count == 0){
    UpdateHomeScreenValued.topValues.removeAllObjects()
    UpdateHomeScreenValued.bottomValues.removeAllObjects()
    UpdateHomeScreenValued.topValues.addObjects(from: ["0.00",PercentageCalculation.scannedAmount,PercentageCalculation.scannedAmount])
    UpdateHomeScreenValued.bottomValues.addObjects(from: ["0.00",PercentageCalculation.ConvertedAmount,PercentageCalculation.ConvertedAmount])
  }
}else{
  UpdateHomeScreenValued.topValues.removeAllObjects()
  UpdateHomeScreenValued.bottomValues.removeAllObjects()
  UpdateHomeScreenValued.topValues.addObjects(from: ["0.00","0 \(locationProperties.shared.countryCode!)","0 \(locationProperties.shared.countryCode!)"])
  UpdateHomeScreenValued.bottomValues.addObjects(from: ["0.00","0.00 AUD","0.00 AUD"])
}
}
