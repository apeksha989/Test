//
//  chooseCurrencyCell.swift
//  Haggle
//
//  Created by Anil Kumar on 17/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class ChooseCurrencyCell: UITableViewCell , UITextFieldDelegate{

      
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
  
  let chooseCurrency = UILabelFactory(text: "")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(with: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1))
  .build()
  
  let countryName = UILabelFactory(text: "")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(with: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1))
  .build()
  
  let iconImage = UIImageFactory()
  .build()
  
  let chooseCurrencyDropdown = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Drop_Down")
  .build()
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return false
  }
  

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
        addSubview(countryName)
        addSubview(iconImage)
        addSubview(ContentView)
      
        ContentView.addSubview(countryName)
        ContentView.addSubview(iconImage)
        ContentView.addSubview(chooseCurrency)
        ContentView.addSubview(chooseCurrencyDropdown)
        
        bringSubviewToFront(ContentView)
        ContentView.bringSubviewToFront(countryName)
        ContentView.bringSubviewToFront(iconImage)
        ContentView.bringSubviewToFront(chooseCurrency)
        ContentView.bringSubviewToFront(chooseCurrency)
      
        ContentView.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
        
        chooseCurrency.layoutAnchor(top: ContentView.topAnchor, left: ContentView.leftAnchor, bottom: ContentView.bottomAnchor, right: chooseCurrencyDropdown.leftAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 30.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        chooseCurrencyDropdown.layoutAnchor(top: nil, left: nil, bottom: nil, right: ContentView.rightAnchor, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 15.0, width: 15.0, height: 9.0, enableInsets: true)
      
        iconImage.layoutAnchor(top: nil, left: ContentView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: ContentView.centerYAnchor, paddingTop: 0.0, paddingLeft: 30, paddingBottom: 0.0, paddingRight: 0.0, width: 35, height: 35, enableInsets: true)
      
        countryName.layoutAnchor(top: nil, left: iconImage.rightAnchor, bottom: nil, right: chooseCurrencyDropdown.leftAnchor, centerX: nil, centerY: ContentView.centerYAnchor, paddingTop: 0.0, paddingLeft: 30, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 30, enableInsets: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
