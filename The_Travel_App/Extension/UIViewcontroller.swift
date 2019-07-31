//
//  UIViewcontroller.swift
//  Haggle
//
//  Created by Anil Kumar on 29/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController{
  
  func popOrPushToViewController(_ strTargetControllerClass: String) {
    switch strTargetControllerClass {
    case "SocialMediaViewController":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "WelcomeScreen":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "OnBoardingScreens":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "ViewController":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "RealtimeCaptureController":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "ManualInputController":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "CountryViewController":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "InstagramLogInViewController":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "HomeViewController":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "SideMenuViewController":
        popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "MyNavigationController":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    case "KYDrawerController":
      popOrPushToApprovePassportCapture(controller: strTargetControllerClass)
    default:
      privatePopOrPushToViewController(strTargetControllerClass)
    }
  }
  private func popOrPushToApprovePassportCapture (controller: String) {
    self.privatePopOrPushToViewController(controller)
  }
  
  func presentDissmiss(controller ControllerName: String){
      let presentControllerName = storyboardViewControllerFromString(ControllerName)!
      present(presentControllerName, animated: true, completion: nil)
  }
  
  private func privatePopOrPushToViewController(_ strTargetControllerClass: String) {
    //TODO: clear this when the scanner returns rather than as an afterthought
    //get the list of controllers in the stack

    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
    
    var i = 0
    var boolDidPop = false
    //Check if the controller we want is in the stack and pop to it if available
    for viewController in viewControllers {
      if String(describing: type(of: viewController)) == strTargetControllerClass {
        self.navigationController!.popToViewController(viewController, animated: true)
        boolDidPop = true
      }
      i = i + 1
    }
    //if we haven't popped yet, that means the viewcontroller wasn't in the stack so we must instatiate it and push it to the stack
    if !boolDidPop {
      //There is an uncatchable runtime error if the controller doesn't exist on the storyboard so there is no point checking for nil
      let targetViewController = storyboardViewControllerFromString(strTargetControllerClass)!
      self.navigationController!.pushViewController(targetViewController, animated: true)
    }
  }
  
  func storyboardViewControllerFromString(_ className : String) -> UIViewController? {
    let storyboard:UIStoryboard
    switch className {
    case "SocialMediaViewController", "WelcomeScreen", "OnBoardingScreens", "ViewController", "RealtimeCaptureController", "ManualInputController", "CountryViewController", "InstagramLogInViewController", "HomeViewController", "SideMenuViewController", "MyNavigationController", "KYDrawerController":
      storyboard = NavigationController.sharedInstance.mainStoryboard
    default :
      storyboard = NavigationController.sharedInstance.mainStoryboard
    }
    return storyboard.instantiateViewController(withIdentifier: className)
  }
}

extension UIViewController {
  var isModal: Bool {
    if let index = navigationController?.viewControllers.index(of: self), index > 0 {
      return false
    } else if presentingViewController != nil {
      return true
    } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
      return true
    } else if tabBarController?.presentingViewController is UITabBarController {
      return true
    } else {
      return false
    }
  }
}
