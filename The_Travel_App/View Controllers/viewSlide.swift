//
//  Slide.swift
//  Haggle
//
//  Created by Anil Kumar on 17/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation

class viewSlide: UIView{
  
  let titleLabel = UILabel()
  let descLabel = UILabel()
  
  override init(frame: CGRect){
    super.init(frame: frame)
    
    titleLabel.adjustsFontSizeToFitWidth = true
    descLabel.adjustsFontSizeToFitWidth = true
    
    titleLabel.numberOfLines = 0
    descLabel.numberOfLines = 0
    
    titleLabel.textColor = UIColor.white
    fontClass.registerFont("Montserrat-Medium", extension: "otf")
    titleLabel.font = UIFont(name: "Montserrat-Medium", size: 24.0)
    
    descLabel.textColor = UIColor.white
    fontClass.registerFont("Montserrat-Regular", extension: "otf")
    descLabel.font = UIFont(name: "Montserrat-Regular", size: 18.0)
    
    titleLabel.textAlignment = .left
    descLabel.textAlignment = .left
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    descLabel.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(titleLabel)
    self.addSubview(descLabel)
    
    titleLabel.layoutAnchor(top: nil, left: leftAnchor, bottom: descLabel.topAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 30, paddingBottom: 15.0, paddingRight: 0.0, width: 150, height: 50, enableInsets: true)
    
    descLabel.layoutAnchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, centerX: centerXAnchor, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 30, paddingBottom: 0.0, paddingRight: 20, width: 0.0, height: 50, enableInsets: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
