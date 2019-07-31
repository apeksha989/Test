//
//  UIStackViewFactory.swift
//  Haggle
//
//  Created by Anil Kumar on 03/05/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import UIKit

final class UIStackViewFactory {
  
  private let stackview: UIStackView
 
  init(buttons: [UIButton]) {
    stackview = UIStackView()
    stackview.translatesAutoresizingMaskIntoConstraints = false
    stackview.axis = .horizontal
    stackview.alignment = .fill
    stackview.distribution = .fillEqually
    stackview.spacing = 30
    buttons.forEach { (btns) in
      stackview.addArrangedSubview(btns)
    }
  }
  
  func addsubview(array button : UIButton)  {
    stackview.addArrangedSubview(button)
//    return self
  }
  
  func build() -> UIStackView {
    return stackview
  }
  
}
