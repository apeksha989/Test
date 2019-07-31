//
//  TableMenuViewCell.swift
//  haggleDemo
//
//  Created by Anil Kumar on 01/04/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit

class TableMenuViewCell: UITableViewCell {
  
  let menuIcon = UIImageFactory()
  .build()
  
  let menuName = UILabelFactory(text: "")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 15)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(menuIcon)
    addSubview(menuName)
    
    bringSubviewToFront(menuIcon)
    bringSubviewToFront(menuName)
    
    setUpConstraintsToAttributes()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpConstraintsToAttributes(){
    menuIcon.layoutAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 5.0, paddingBottom: 0.0, paddingRight: 0.0, width: 40.0, height: 40.0, enableInsets: true)
    
    menuName.layoutAnchor(top: nil, left: menuIcon.rightAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: menuIcon.centerYAnchor, paddingTop: 0.0, paddingLeft: 27.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
    
  }
}
