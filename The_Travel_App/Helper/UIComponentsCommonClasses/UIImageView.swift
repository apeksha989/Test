//
//  UIImageView.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 17/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation


final class UIImageFactory {
  private let imageView: UIImageView
  
  init(){
    imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func CornerRadious(radious: CGFloat)->Self{
    imageView.layer.cornerRadius = radious
    return self
  }
  
  func backgroundColor(color:UIColor)->Self{
    imageView.backgroundColor = color
    return self
  }
  func setImage(imageString: String)->Self{
    imageView.image = UIImage(named: imageString)
    return self
  }
  
  func build() -> UIImageView {
    return imageView
  }
  
}
