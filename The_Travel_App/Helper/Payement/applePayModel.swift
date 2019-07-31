//
//  applePayModel.swift
//  The Travel App
//
//  Created by Anil Kumar on 16/05/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import PassKit
import Stripe
import UIKit
import Alamofire

protocol applePayDelegate: class {
  func paymentSuccess(paymentSuccess: PKPaymentAuthorizationStatus)
}

class ApplePayController: NSObject {
  
  private static var privateSharedInstance: ApplePayController?
  static var sharedInstance: ApplePayController {
    if privateSharedInstance == nil {
      privateSharedInstance = ApplePayController()
    }
    return privateSharedInstance!
  }
  class func destroy() {
    privateSharedInstance = nil
  }
  
  
  var amountValue = Int()
  var currencyCode = String()
  
  weak var delegate: applePayDelegate? = nil
  
  func paymentClicked(parent viewController: UIViewController,countryCode: String,currencyCode: String,ProductName:String,amount:NSDecimalNumber){
    let request = PKPaymentRequest()
    request.merchantIdentifier = Key.Stripe.appleMerchantIdentifier
    request.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    request.merchantCapabilities = PKMerchantCapability.capability3DS
    request.countryCode = countryCode.uppercased()
    request.currencyCode = currencyCode
    self.currencyCode = currencyCode
    self.amountValue = Int(truncating: amount)
    print(self.amountValue)
    request.paymentSummaryItems = [
      PKPaymentSummaryItem(label: ProductName, amount: amount)
    ]
    
    guard let PkPaymentController = PKPaymentAuthorizationViewController(paymentRequest: request) else {
      viewController.showConfirmAlert(title: "", message: "Does not support your device with apple Pay!", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
      return
    }
    PkPaymentController.delegate = self
    viewController.present(PkPaymentController, animated: true, completion: nil)
  }
}
extension ApplePayController: PKPaymentAuthorizationViewControllerDelegate {
  
  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
  @available(iOS 11.0, *)
  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    delegate?.paymentSuccess(paymentSuccess: PKPaymentAuthorizationStatus.success)
    
    // Use Stripe to charge the user
    STPAPIClient.shared().createToken(with: payment) { (stripeToken, error) in
      guard error == nil, let stripeToken = stripeToken else {
        print(error!)
        return
      }
      
      StripePay.shared.completeCharge(with: stripeToken, amount: self.amountValue, currencyCode: self.currencyCode, completion: {
        print("Success")
      })
    }
    
    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    
  }
}










