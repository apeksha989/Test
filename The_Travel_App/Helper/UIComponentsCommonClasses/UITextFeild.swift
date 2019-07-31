//
//  UITextFeild.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 17/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation


final class UITextFieldFactory{
  
  private let textFeild: UITextField
  
  init() {
    textFeild = UITextField()
    textFeild.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setBorderStyle(with style: UITextField.BorderStyle)->Self{
    textFeild.borderStyle = style
    return self
  }
  
  func setKeyboardType(type: UIKeyboardType)->Self{
    textFeild.keyboardType = type
    return self
  }
  
  func setKeyboardReturnType(type: UIReturnKeyType)-> Self{
    textFeild.returnKeyType = type
    return self
  }
  
  func textAlignment(with:NSTextAlignment)->Self{
    textFeild.textAlignment = with
    return self
  }
  
  func spellCheckingType(with:UITextSpellCheckingType)->Self{
    textFeild.spellCheckingType = with
    return self
  }
  
  func autocorrectionType(with: UITextAutocorrectionType)->Self{
    textFeild.autocorrectionType = with
    return self
  }
  
  func setFont(font: UIFont)->Self{
    textFeild.font = font
    return self
  }
  
  func textColor(color:UIColor)->Self{
    textFeild.textColor = color
    return self
  }
  
  func build() -> UITextField {
    return textFeild
  }
  
}



