//
//  toastExtension.swift
//  Haggle
//
//  Created by Anil Kumar on 25/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import UIKit



class Toast {
  
  
  
  private static var privateSharedInstance: Toast?
  static var sharedInstance: Toast {
    if privateSharedInstance == nil {
      privateSharedInstance = Toast()
    }
    return privateSharedInstance!
  }
  class func destroy() {
    privateSharedInstance = nil
  }
  
  var viewControllerInstance = UIViewController()
  let toastContainer = UIView(frame: CGRect())
  var toastLabel = UILabelFactory(text: "")
    .build()
  
  func show(message: String, controller: UIViewController) {
    
    toastContainer.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    toastContainer.alpha = 0.0
    toastContainer.layer.cornerRadius = 25;
    toastContainer.clipsToBounds  =  true
    
    let toastLabel = UILabel(frame: CGRect())
    toastLabel.textAlignment = .center;
    toastLabel.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    toastLabel.font = UIFont(name: "Montserrat-Medium", size: 15.0)
    toastLabel.text = message
    toastLabel.clipsToBounds  =  true
    toastLabel.numberOfLines = 0
    
    toastContainer.addSubview(toastLabel)
    controller.view.addSubview(toastContainer)
    controller.view.bringSubviewToFront(toastContainer)
    
    toastLabel.translatesAutoresizingMaskIntoConstraints = false
    toastContainer.translatesAutoresizingMaskIntoConstraints = false
    
    let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
    let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
    let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
    let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
    toastContainer.addConstraints([a1, a2, a3, a4])
    
    let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
    let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
    let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
    controller.view.addConstraints([c1, c2, c3])
    
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
      self?.toastContainer.alpha = 1.0
    }, completion: { _ in  })
  }
   
  func hideToast(){
    self.toastContainer.removeFromSuperview()
  }
  
  func showLongToast( message: String, controller: UIViewController) {
    viewControllerInstance = controller
    toastLabel = UILabel(frame: CGRect(x: controller.view.frame.origin.x + 20, y: controller.view.frame.size.height-200, width: controller.view.frame.size.width - 40, height: 80))
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
    toastLabel.addGestureRecognizer(tap)
    toastLabel.isUserInteractionEnabled = true
//    toastLabel.padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    toastLabel.numberOfLines = 0
    toastLabel.textAlignment = .center
    toastLabel.contentMode = .center
    toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    toastLabel.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    toastLabel.font = UIFont(name: "Montserrat-Medium", size: 13.0)
    let trimmedString = message.trimmingCharacters(in: .whitespacesAndNewlines)
    let string = NSMutableAttributedString(string: trimmedString, attributes: [NSAttributedString.Key.font:UIFont(name: "Montserrat-Medium", size: 13.0)!])
    string.setColorForText("Enter Manually", with: #colorLiteral(red: 1, green: 0.4196078431, blue: 0.1812392979, alpha: 1))
    toastLabel.attributedText = string
    toastLabel.layer.cornerRadius = 25
    toastLabel.clipsToBounds = true
    controller.view.addSubview(toastLabel)
    controller.view.bringSubviewToFront(toastLabel)
  }
  

  func removeLongToast(){
    toastLabel.removeFromSuperview()
  }
  
  @objc func tapLabel(tap: UITapGestureRecognizer) {
        
    let text = (toastLabel.text)!
    let termsRange = (text as NSString).range(of: "Enter Manually")

    if tap.didTapAttributedTextInLabel(label: toastLabel, inRange: termsRange) {
      removeLongToast()
      viewControllerInstance.popOrPushToViewController("ManualInputController")
    } else {
      removeLongToast()
      viewControllerInstance.popOrPushToViewController("ManualInputController")
    }
  }
}
