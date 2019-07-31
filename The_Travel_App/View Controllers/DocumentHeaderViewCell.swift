//
//  DocumentHeaderViewCell.swift
//  Haggle
//
//  Created by Anil Kumar on 22/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class DocumentHeaderViewCell: UICollectionViewCell {
    
    let header    = UILabelFactory(text: "")
      .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 22)!)
      .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
  .build()
      
    override func awakeFromNib() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(header)
        
        header.layoutAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 20.0, paddingBottom: 0.0, paddingRight: 0.0, width: 100.0, height: 28.0, enableInsets: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
