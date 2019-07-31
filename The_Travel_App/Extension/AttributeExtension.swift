//
//  LayoutAttributes.swift
//  Haggle
//
//  Created by Anil Kumar on 28/02/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
  
  func bringSubView(stackview: UIStackView){
    view.bringSubviewToFront(stackview)
  }
  
  func bringSubView(button: UIButton){
    view.bringSubviewToFront(button)
  }
  
  func bringSubView(label: UILabel){
    view.bringSubviewToFront(label)
  }
}

class getImageFromBundleClass: UIImage{
 static func getImageFromBundle(_ imageName: String)-> UIImage{
    let image = UIImage()
//  com.perfutilconsultingltd.HaggleSDK
    if let image = UIImage(named: imageName, in: Bundle(identifier: BudleIdentifire.Identifire), compatibleWith: nil){
      return image
    }else{
      return image
    }
  }
}

class fontClass{
//  com.perfutilconsultingltd.HaggleSDK
  static func registerFont(_ fontName: String, extension: String) {
    let bundle = Bundle(identifier: "com.perfutilconsultingltd.haggle")
    guard let fontURL = bundle!.url(forResource: fontName, withExtension: `extension`) else { return }
    CTFontManagerRegisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, nil)
  }
}
