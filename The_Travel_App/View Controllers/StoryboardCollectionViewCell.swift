//
//  StoryboardCollectionViewCell.swift
//  haggleDemo
//
//  Created by Anil Kumar on 30/03/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit

class StoryboardCollectionViewCell: UICollectionViewCell {
  var backgroundImage : UIImageView = {
    let bgImage = UIImageView()
    bgImage.translatesAutoresizingMaskIntoConstraints = false
    return bgImage
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "Montserrat-SemiBold", size: 24)
    label.textColor = UIColor.white
    return label
  }()
  
  lazy var tripBudgetLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "Montserrat-SemiBold", size: 9)
    label.textColor = UIColor.white
    return label
  }()
  
  lazy var tripBudgetAmountLabel: UILabel = {
    let label = UILabel()
    label.text = "Loading..."
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "Montserrat-Medium", size: 31)
    label.textColor = UIColor.white
    return label
  }()
  
  lazy var homeCurrencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "Montserrat-SemiBold", size: 9)
    label.textColor = UIColor.white
    return label
  }()
  
  lazy var homeCurrencyAmountLabel: UILabel = {
    let label = UILabel()
    label.text = "Loading..."
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "Montserrat-Medium", size: 23)
    label.textColor = UIColor.white
    return label
  }()
  override func awakeFromNib() {
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.contentView.layer.cornerRadius = 10.0
    self.contentView.clipsToBounds = true
    
    addSubview(backgroundImage)
    backgroundImage.addSubview(titleLabel)
    backgroundImage.bringSubviewToFront(titleLabel)
    backgroundImage.addSubview(tripBudgetLabel)
    backgroundImage.bringSubviewToFront(tripBudgetLabel)
    backgroundImage.addSubview(tripBudgetAmountLabel)
    backgroundImage.bringSubviewToFront(tripBudgetAmountLabel)
    backgroundImage.addSubview(homeCurrencyLabel)
    backgroundImage.bringSubviewToFront(homeCurrencyLabel)
    backgroundImage.addSubview(homeCurrencyAmountLabel)
    backgroundImage.bringSubviewToFront(homeCurrencyAmountLabel)
    
    backgroundImage.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    
    titleLabel.layoutAnchor(top: backgroundImage.topAnchor, left: backgroundImage.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 30, paddingLeft: 40, paddingBottom: 0.0, paddingRight: 0.0, width: 100, height: 30, enableInsets: true)
    
    tripBudgetLabel.layoutAnchor(top: nil, left: backgroundImage.leftAnchor, bottom: tripBudgetAmountLabel.topAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 40, paddingBottom: 0, paddingRight: 0.0, width: 81, height: 13, enableInsets: true)
    
    tripBudgetAmountLabel.layoutAnchor(top: nil, left: backgroundImage.leftAnchor, bottom: homeCurrencyLabel.topAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 40.0, paddingBottom: 0.0, paddingRight: 0.0, width: backgroundImage.frame.size.width, height: 40, enableInsets: true)
    
    homeCurrencyLabel.layoutAnchor(top: nil, left: backgroundImage.leftAnchor, bottom: homeCurrencyAmountLabel.topAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 40, paddingBottom: 0.0, paddingRight: 0.0, width: 75, height: 15, enableInsets: true)
    
    homeCurrencyAmountLabel.layoutAnchor(top: nil, left: backgroundImage.leftAnchor, bottom: backgroundImage.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 40.0, paddingBottom: 30.0, paddingRight: 0.0, width: backgroundImage.frame.size.width, height: 30, enableInsets: true)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

