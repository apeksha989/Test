//
//  StripeService.swift
//  AddcardViewStripe
//
//  Created by Anilkumar on 10/05/19.
//  Copyright © 2019 Anilkumar. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class StripePay: NSObject {
    class var shared: StripePay {
        struct Singleton {
            static let instance = StripePay()
        }
        return Singleton.instance
}
  func completeCharge(with token: STPToken, amount: Int,currencyCode: String,completion: @escaping () -> Void) {
        let baseURL = "https://api.stripe.com/v1/charges?key=\(Key.Stripe.secratKey)"
        // 2
        let params: [String: Any] = [
            //check source to web
            "source": "tok_visa",
            "amount": (amount * 100),
            "currency": "\(currencyCode)",
            "description": "Testranjithagemmm",
//            "capture":"\(false)"
        ]
        Alamofire.request(baseURL, method: .post, parameters: params, encoding: URLEncoding.default) .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                //Success
                print(JSON)
            case .failure(let error):
                //Failure
                print(error.localizedDescription)
            }
        }
    }
    func plan(interval:String,intervalCount:Int,amount: Int,completion: @escaping () -> Void) {
        let baseURL = "https://api.stripe.com/v1/plans?key=\(Key.Stripe.secratKey)"
        let params2: [String: Any] = [
            "amount": amount,
            "currency": "USD",
            "interval":interval,
            "interval_count":intervalCount,
            "product[name]":"TestRanjitha287",
           //check charge id to web
            "id":"gold"
            ]
        Alamofire.request(baseURL, method: .post, parameters: params2, encoding: URLEncoding.default) .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                //Success
                print(JSON)
            case .failure(let error):
                //Failure
                print(error.localizedDescription)
            }
        }
    }
    func capture(){
        let baseURL = "https://api.stripe.com/v1/charges/ch_1EYXY4DyrENmPy0AfxOWPD5L/capture?key=\(Key.Stripe.secratKey)"
          let params3: [String: Any] = [
            :]
        Alamofire.request(baseURL, method: .post, parameters: params3, encoding: URLEncoding.default) .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                //Success
                print(JSON)
            case .failure(let error):
                //Failure
                print(error.localizedDescription)
            }
        }
    }
//create the custome;-
    func newCustomer(mailId:String,completion: @escaping () -> Void){
        let baseURL = "https://api.stripe.com/v1/customers?key=\(Key.Stripe.secratKey)"
        let params4: [String: Any] = [
            "email":mailId,
            "source":"tok_visa"
        ]
        Alamofire.request(baseURL, method: .post, parameters: params4, encoding: URLEncoding.default) .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                //Success
                print(JSON)
            case .failure(let error):
                //Failure
                print(error.localizedDescription)
            }
        }
    }
    // create the plan;-
    // create the trail period;-[pass trail period days-16.5.2019]
    func plan(amount:Int,interval:String,completion: @escaping () -> Void){
        let baseURL = "https://api.stripe.com/v1/plans?key=\(Key.Stripe.secratKey)"
        let parms5:[String: Any] = [
            "amount":amount,
            "interval":interval,
            "product[name]":"Testinggemworld33",
            "currency":"USD",
            "trial_period_days":30
        ]
        Alamofire.request(baseURL, method: .post, parameters: parms5, encoding: URLEncoding.default) .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                //Success
                print(JSON)
            case .failure(let error):
                //Failure
                print(error.localizedDescription)
            }
        }
    }
    //  create Subscription;-
   func subscription(){
        let baseURL = "https://api.stripe.com/v1/subscriptions?key=\(Key.Stripe.secratKey)"
        let parms6:[String: Any] = [
        "items[0][plan]": "plan_F3lKbi4UM7chzS",
        "customer":"cus_F3lHlKbQZ2C54f",
        "trial_end":"1558153774"
        ]
        Alamofire.request(baseURL, method: .post, parameters: parms6, encoding: URLEncoding.default) .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                //Success
                print(JSON)
            case .failure(let error):
                //Failure
                print(error.localizedDescription)
            }
        }
    }
    // cancel or pause the subscription;-
    func cancelSubscription(){
        let baseURL = "https://api.stripe.com/v1/subscriptions/sub_F3lM9rxghZfrGC?key=\(Key.Stripe.secratKey)"
        let parms6:[String: Any] = [:]
        Alamofire.request(baseURL, method: .delete, parameters: parms6, encoding: URLEncoding.default) .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                //Success
                print(JSON)
            case .failure(let error):
                //Failure
                print(error.localizedDescription)
            }
        }
    }
    //Amount Refund;-
    func refund(){
        let baseURL = "https://api.stripe.com/v1/refunds?key=\(Key.Stripe.secratKey)"
        let parms7:[String: Any] = [
            "charge":"ch_1EZe25DyrENmPy0A8mYxraSD"
        ]
        Alamofire.request(baseURL, method: .delete, parameters: parms7, encoding: URLEncoding.default) .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                //Success
                print(JSON)
            case .failure(let error):
                //Failure
                print(error.localizedDescription)
            }
        }
    }
    func coupen(){
        let baseURL = "https://api.stripe.com/v1/coupons?key=\(Key.Stripe.secratKey)"
        let parms8:[String: Any] = [
            "percent_off":"25",
            "duration":"repeating",
            "duration_in_months":"1"
        ]
        Alamofire.request(baseURL, method: .delete, parameters: parms8, encoding: URLEncoding.default) .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                //Success
                print(JSON)
            case .failure(let error):
                //Failure
                print(error.localizedDescription)
            }
        }
    }
}
