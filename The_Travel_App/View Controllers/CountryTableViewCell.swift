//
//  CountryTableViewCell.swift
//  popUp
//
//  Created by Anil Kumar on 15/03/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
  
  let ContentView = UIViewFactory()
    .clipToBounds(Bool: true)
    .masksToBounds(Bool: false)
    .shadowColor(color: UIColor(red: 0.85, green: 0.89, blue: 0.91, alpha: 0.50))
    .shadowOpacity(opaCity: 0.7)
    .shadowRadious(with: 2)
    .shadowOffset(offSetWith: 0, offSetHeignt: 5)
    .cornerRadious(value: 6)
    .borderWith(value: 1)
    .borderColor(color: UIColor(red: 0.86, green: 0.87, blue: 0.89, alpha: 0.30))
    .backgroundColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .setAlpha(alpha: 1)
  .build()
  
  
  let countryIcon = UIImageFactory()
  .build()
  
  let currencyCodeLabel = UILabelFactory(text: "")
//    .adjustFontSize(Bool: true)
    .numberOf(lines: 0)
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 15.0)!)
    .textColor(with: UIColor(red: 0.282, green: 0.329, blue: 0.396, alpha: 1.0))
  .build()
  
  let arrowImage = UIImageFactory()
    .setImage(imageString: "next")
  .build()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(ContentView)
    ContentView.addSubview(countryIcon)
    ContentView.addSubview(currencyCodeLabel)
    ContentView.addSubview(arrowImage)
    
    bringSubviewToFront(ContentView)
    ContentView.bringSubviewToFront(countryIcon)
    ContentView.bringSubviewToFront(currencyCodeLabel)
    ContentView.bringSubviewToFront(arrowImage)
    
    ContentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: false)
    countryIcon.anchor1(top: nil, left: ContentView.leftAnchor, bottom: nil, right: nil, centerY: ContentView.centerYAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 20, paddingRight: 0.0, width: 30.0, height: 30.0, enableInsets: false)
    currencyCodeLabel.anchor1(top: ContentView.topAnchor, left: countryIcon.rightAnchor, bottom: ContentView.bottomAnchor, right: arrowImage.leftAnchor, centerY: centerYAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: false)
    arrowImage.anchor1(top: nil, left: nil, bottom: nil, right: ContentView.rightAnchor, centerY: ContentView.centerYAnchor, paddingTop: 0, paddingLeft: 0.0, paddingBottom: 0, paddingRight: 10.0, width: 25.0, height: 25.0, enableInsets: false)
    
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
