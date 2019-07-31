//
//  UIButtonFactory.swift
//  Haggle
//
//  Created by Anil Kumar on 03/05/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import UIKit

final class UIButtonFactory {
  private let button: UIButton
  
  enum Style {
    case normal
    case especial
  }
  
  // MARK: - Inits
  init(title: String, style: Style = .normal) {
    button = UIButton()
    button.setTitle(title, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    switch style {
    case .normal: normalStyle()
    case .especial: especialStyle()
    }
  }
  
  // MARK: - Public methods
  func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event) -> Self {
    button.addTarget(target, action: action, for: event)
    
    return self
  }
  
  func setContendMode(Mode:UIView.ContentMode)->Self{
      button.contentMode = Mode
    return self
  }
  func setTintColor(color :UIColor) -> Self{
    button.tintColor = color
    return self
  }
  
  func textColor(with color: UIColor) -> Self {
    button.titleLabel?.textColor = color
    
    return self
  }
  
  func textAlignmentButton(with Alignment: NSTextAlignment) -> Self{
    button.titleLabel?.textAlignment = Alignment
    
    return self
  }
  
  func setBackgroundImage(image imageName: String) -> Self{
    button.setBackgroundImage(getImageFromBundleClass.getImageFromBundle(imageName), for: .normal)
    return self
  }
  
  func setTitileColour(with color: UIColor)-> Self{
    button.setTitleColor(color, for: .normal)
     return self
  }
  
  func cornerRadious(with radious: CGFloat) -> Self{
    button.layer.cornerRadius = radious
    return self
  }
  
  func textFonts(with font: UIFont) -> Self {
    button.titleLabel?.font = font
    
    return self
  }
  
  func backgroundColour(with color: UIColor)-> Self {
    button.backgroundColor = color
    return self
  }
  
  func registerSDK(Register fontName: String,type: String)-> Self{
    fontClass.registerFont(fontName, extension: type)
    return self
  }    
  
  func build() -> UIButton {
    return button
  }
  
  // MARK: - Private methods
  private func especialStyle() {
    button.layer.cornerRadius = 10
    button.backgroundColor = .green
    button.setTitleColor(.red, for: .normal)
    button.setTitleColor(.white, for: .highlighted)
  }
  
  private func normalStyle() {
    button.setTitleColor(.white, for: .normal)
    button.setTitleColor(.white, for: .highlighted)
  }
}
