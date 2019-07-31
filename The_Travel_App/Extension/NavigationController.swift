//
//  NavigationController.swift
//  Haggle
//
//  Created by Anil Kumar on 29/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class NavigationController: NSObject {
  
  var bundle : Bundle
  var mainStoryboard : UIStoryboard
  var navigationController: UINavigationController
  
//  var targetName = Bundle.main.infoDictionary?["CFBundleName"] as? String
  private static var privateSharedInstance: NavigationController?
  static var sharedInstance: NavigationController {
    if privateSharedInstance == nil {
      privateSharedInstance = NavigationController()
    }
    return privateSharedInstance!
  }
  class func destroy() {
    privateSharedInstance = nil
  }
  
  override init ()
  {
//    var tempBundle : Bundle?
//    if targetName == "The_Travel_App"{
//      //Use the main app
//      tempBundle = Bundle.main
//    } else {
//      //Use our SDK
//      tempBundle = Bundle.init(identifier: "The_Travel_App")
//    }
//    mainStoryboard = UIStoryboard(name: "Main", bundle: tempBundle)
//    bundle = tempBundle!
//    navigationController = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
    
    let targetName = Bundle.main.infoDictionary?["CFBundleName"] as? String
    var tempBundle : Bundle?
    if targetName == "The Travel App"{
      //Use the main app
      tempBundle = Bundle.main
    } else {
      //Use our SDK
      tempBundle = Bundle.init(identifier: BudleIdentifire.Identifire)
    }
    mainStoryboard = UIStoryboard(name: "Main", bundle: tempBundle)
    bundle = tempBundle!
    navigationController = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
    
    super.init()
  }
  
  func storyboardViewControllerFromString(_ className : String) -> UIViewController? {
    let storyboard:UIStoryboard
    switch className {
    case "SocialMediaViewController", "WelcomeScreen", "OnBoardingScreens", "ViewController", "RealtimeCaptureController", "ManualInputController", "CountryViewController", "InstagramLogInViewController", "HomeViewController", "SideMenuViewController", "MyNavigationController", "KYDrawerController", "LeftViewController":
      storyboard = NavigationController.sharedInstance.mainStoryboard
    default :
      storyboard = NavigationController.sharedInstance.mainStoryboard
    }
    return storyboard.instantiateViewController(withIdentifier: className)
  }
  
  
  // To get the current view controller
  static func getCurrentViewController(_ vc: UIViewController) -> UIViewController? {
    if let presentViewControllers = vc.presentedViewController {
      return getCurrentViewController(presentViewControllers)
    }
    else if let splitViewControllers = vc as? UISplitViewController, splitViewControllers.viewControllers.count > 0 {
      return getCurrentViewController(splitViewControllers.viewControllers.last!)
    }
    else if let navigationControllers = vc as? UINavigationController, navigationControllers.viewControllers.count > 0 {
      return getCurrentViewController(navigationControllers.topViewController!)
    }
    else if let tabBarViewControllers = vc as? UITabBarController {
      if let selectedViewController = tabBarViewControllers.selectedViewController {
        return getCurrentViewController(selectedViewController)
      }
    }
    return vc
  }
}

