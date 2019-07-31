//
//  addNameCell.swift
//  Haggle
//
//  Created by Anil Kumar on 17/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class AddNameCell: UITableViewCell, UITextFieldDelegate {
  
  let ContentView = UIViewFactory()
    .clipToBounds(Bool: true)
    .masksToBounds(Bool: false)
    .shadowColor(color: UIColor(red: 0.85, green: 0.89, blue: 0.91, alpha: 0.50))
    .shadowOpacity(opaCity: 0.7)
    .shadowRadious(with: 2)
    .shadowOffset(offSetWith: 5, offSetHeignt: 5)
    .cornerRadious(value: 6)
    .borderColor(color: UIColor(red: 0.86, green: 0.87, blue: 0.89, alpha: 0.30))
    .borderWith(value: 1)
    .backgroundColor(color:  UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .setAlpha(alpha: 1)
  .build()

  let tripName = UITextFieldFactory()
    .setFont(font: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(color: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1))
  .build()
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tripName.delegate = self
        addSubview(ContentView)
        ContentView.addSubview(tripName)
        
        bringSubviewToFront(ContentView)
        ContentView.bringSubviewToFront(tripName)
        
        tripName.delegate = self
        
        ContentView.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
        
        tripName.layoutAnchor(top: ContentView.topAnchor, left: ContentView.leftAnchor, bottom: ContentView.bottomAnchor, right: ContentView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 30.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tripName.resignFirstResponder()
        return true
    }
}

