//
//  WalletIDViewCell.swift
//  Haggle
//
//  Created by Anil Kumar on 22/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class WalletIDViewCell: UITableViewCell {
  
  let idImage = UIImageFactory()
  .build()
  
  let idName = UILabelFactory(text: "")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 16)!)
    .textColor(with: UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1))
  .build()
  
  let idVerifiedDate = UILabelFactory(text: "Verified on June 10, 2018")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 12)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  let idRenewalDate = UILabelFactory(text: "Renewal on June 10, 2024")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 9)!)
    .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
  .build()
  
  let idNavigation = UIImageFactory()
  .build()
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(idImage)
        addSubview(idName)
        addSubview(idVerifiedDate)
        addSubview(idRenewalDate)
        addSubview(idNavigation)
        
        idImage.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 5.0, paddingBottom: 0.0, paddingRight: 0.0, width: 71.0, height: 71.0, enableInsets: true)
        
        idName.layoutAnchor(top: topAnchor, left: idImage.rightAnchor, bottom: nil, right: idNavigation.leftAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 22.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
        
        idVerifiedDate.layoutAnchor(top: idName.bottomAnchor, left: idName.leftAnchor, bottom: nil, right: idNavigation.leftAnchor, centerX: nil, centerY: nil, paddingTop: 7.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 15.0, enableInsets: true)
        
        idRenewalDate.layoutAnchor(top: idVerifiedDate.bottomAnchor, left: idName.leftAnchor, bottom: nil, right: idNavigation.leftAnchor, centerX: nil, centerY: nil, paddingTop: 4.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 12.0, enableInsets: true)
        
        idNavigation.layoutAnchor(top: nil, left: nil, bottom: nil, right: rightAnchor, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 10.0, width: 17.0, height: 24.0, enableInsets: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
