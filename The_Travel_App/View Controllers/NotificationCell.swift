//
//  NotificationCell.swift
//  haggleDemo
//
//  Created by Anil Kumar on 01/04/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
  
  let notificationIcon = UIImageFactory()
  .build()
  
  let notiificationTitle = UILabelFactory(text: "")
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 14)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  let notificationDetail = UILabelFactory(text: "")
    .numberOf(lines: 0)
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 12)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  let notificationDays = UILabelFactory(text: "")
    .textAlignment(with: .right)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 10)!)
    .textColor(with: UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1))
  .build()
    
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(notificationIcon)
    addSubview(notiificationTitle)
    addSubview(notificationDetail)
    addSubview(notificationDays)
    
    bringSubviewToFront(notificationIcon)
    bringSubviewToFront(notiificationTitle)
    bringSubviewToFront(notificationDetail)
    bringSubviewToFront(notificationDays)
    
    notificationIcon.layoutAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 50.0, height: 50.0, enableInsets: true)
    
    notiificationTitle.layoutAnchor(top: topAnchor, left: notificationIcon.rightAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 16.0, paddingLeft: 28.0, paddingBottom: 0.0, paddingRight: 0.0, width: 105.0, height: 20, enableInsets: true)
    
    notificationDetail.layoutAnchor(top: notiificationTitle.bottomAnchor, left: notificationIcon.rightAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 28.0, paddingBottom: 0.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
    
    notificationDays.layoutAnchor(top: topAnchor, left: notiificationTitle.rightAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 20.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 14.0, enableInsets: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

