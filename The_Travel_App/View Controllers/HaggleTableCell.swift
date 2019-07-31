//
//  HaggleTableCell.swift
//  Haggle
//
//  Created by Anil Kumar on 15/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class HaggleTableCell: UITableViewCell {
  
  let hagglePercentage = UILabelFactory(text: "")
    .textAlignment(with: .center)
    .textFonts(with:  UIFont(name: "Montserrat-Regular", size: 15)!)
    .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
    .build()
  
  let haggleAmount     = UILabelFactory(text: "")
    .textAlignment(with: .left)
    .textFonts(with:  UIFont(name: "Montserrat-Regular", size: 22)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
    .build()
  
  let targetAmount     = UILabelFactory(text: "")
    .textAlignment(with: .left)
    .adjustFontSize(Bool: true)
    .textFonts(with:  UIFont(name: "Montserrat-Medium", size: 10)!)
    .textColor(with: UIColor(red: 1.00, green: 0.42, blue: 0.18, alpha: 1))
    .build()
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(hagglePercentage)
        addSubview(haggleAmount)
        addSubview(targetAmount)
        
        bringSubviewToFront(hagglePercentage)
        bringSubviewToFront(haggleAmount)
        bringSubviewToFront(targetAmount)
        
        hagglePercentage.layoutAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 34.0, paddingBottom: 0.0, paddingRight: 0.0, width: 40.0, height: 20, enableInsets: true)
        
        haggleAmount.layoutAnchor(top: nil, left: hagglePercentage.rightAnchor, bottom: nil, right: targetAmount.leftAnchor, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 29.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 28, enableInsets: true)
        
        targetAmount.layoutAnchor(top: nil, left: nil, bottom: nil, right: rightAnchor, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 25.0, width: 60.0, height: 15, enableInsets: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
