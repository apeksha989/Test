//
//  DocumentCollectionCell.swift
//  Haggle
//
//  Created by Anil Kumar on 22/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class DocumentCollectionCell: UICollectionViewCell {
  
  let documentImage = UIImageFactory()
  .build()
  
  let documentCreatedDate = UILabelFactory(text: "")
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 12)!)
    .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
  .build()
  
    override func awakeFromNib() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(documentImage)
        addSubview(documentCreatedDate)
        
        documentImage.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 152.0, height: 152.0, enableInsets: true)
        
        documentCreatedDate.layoutAnchor(top: documentImage.bottomAnchor, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 5.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 17.0, enableInsets: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
