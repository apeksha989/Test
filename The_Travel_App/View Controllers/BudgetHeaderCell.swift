//
//  BudgetHeaderCell.swift
//  Haggle
//
//  Created by Anil Kumar on 23/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class BudgetHeaderCell: UITableViewCell {
  
  let budgetHeader = UILabelFactory(text: "Categories")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 12)!)
    .textColor(with: UIColor(red: 0.01, green: 0.59, blue: 0.85, alpha: 1))
  .build()
  
  let addNewButton = UIButtonFactory(title: "Add New")
    .setTitileColour(with: UIColor(red: 1.00, green: 0.42, blue: 0.18, alpha: 1))
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 10)!)
  .build()
  

  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(budgetHeader)
        addSubview(addNewButton)
        
        bringSubviewToFront(addNewButton)
        
        budgetHeader.layoutAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 70.0, height: 17.0, enableInsets: true)
        
        addNewButton.layoutAnchor(top: nil, left: nil, bottom: nil, right: rightAnchor, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 47.0, height: 14.0, enableInsets: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
