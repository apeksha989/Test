//
//  gradiant.swift
//  FlagWithText
//
//  Created by Anil Kumar on 15/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import UIKit


func gradiantView(_ Bar:UIView,_ Controller: UIViewController){
  let gradient: CAGradientLayer = CAGradientLayer()
  gradient.frame = CGRect(x: 0.0, y: 0.0, width: Controller.view.frame.size.width, height: Bar.frame.size.height)
  gradient.colors = [hexStringToUIColor(hex: "#55C6F8").cgColor, hexStringToUIColor(hex: "#3483D9").cgColor]
  Bar.layer.insertSublayer(gradient, at: 0)
}


func gradiantViewButton(_ button:UIButton){
  let gradient = CAGradientLayer()
  button.layer.cornerRadius = 25
  button.backgroundColor = .cyan
  gradient.frame = button.bounds
  gradient.colors = [hexStringToUIColor(hex: "#377ED6").cgColor,hexStringToUIColor(hex: "#00D2FF").cgColor]
  gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
  gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
  button.layer.insertSublayer(gradient, at: 0)
  let path = UIBezierPath(roundedRect:button.bounds, byRoundingCorners:[.bottomRight,.bottomLeft, .topLeft , .topRight], cornerRadii: CGSize(width: 21, height: 21))
  let maskLayer = CAShapeLayer()
  maskLayer.path = path.cgPath
  button.layer.mask = maskLayer 
}


func hexStringToUIColor (hex:String) -> UIColor {
  var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
  
  if (cString.hasPrefix("#")) {
    cString.remove(at: cString.startIndex)
  }
  
  if ((cString.count) != 6) {
    return UIColor.gray
  }
  
  var rgbValue:UInt32 = 0
  Scanner(string: cString).scanHexInt32(&rgbValue)
  
  return UIColor(
    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
    alpha: CGFloat(1.0)
  )
}

