//
//  UIView.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 17/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation


final class UIViewFactory{
  
  private let view: UIView
  
  init() {
    view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func borderWith(value:CGFloat)->Self{
    view.layer.borderWidth = value
    return self
  }
  
  func borderColor(color:UIColor)->Self{
    view.layer.borderColor = color.cgColor
    return self
  }
  
  func backgroundColor(color: UIColor)-> Self{
    view.backgroundColor = color
    return self
  }
  func cornerRadious(value: CGFloat)-> Self{
    view.layer.cornerRadius = value
    return self
  }
  func clipToBounds(Bool: Bool)-> Self{
    view.clipsToBounds = Bool
    return self
  }
  func masksToBounds(Bool: Bool)-> Self {
    view.layer.masksToBounds = Bool
    return self
  }
  
  func shadowColor(color: UIColor)-> Self {
    view.layer.shadowColor = color.cgColor
    return self
  }
  
  func shadowOpacity(opaCity : Float)-> Self {
    view.layer.shadowOpacity = opaCity
    return self
  }
  
  func shadowRadious(with: CGFloat)-> Self{
    view.layer.shadowRadius = with
    return self
  }
  func shadowOffset(offSetWith : CGFloat,offSetHeignt: CGFloat)-> Self {
    view.layer.shadowOffset = CGSize(width: offSetWith, height: offSetHeignt)
    return self
  }
  
  func setAlpha(alpha: CGFloat)-> Self{
    view.alpha = alpha
    return self
  }
  
  func build() -> UIView {
    return view
  }
}

