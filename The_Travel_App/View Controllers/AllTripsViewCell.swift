//
//  AllTripsViewCell.swift
//  Haggle
//
//  Created by Anil Kumar on 19/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class AllTripsViewCell: UITableViewCell {
  
  let ContentView = UIViewFactory()
    .clipToBounds(Bool: true)
    .masksToBounds(Bool: false)
    .shadowColor(color: UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.50))
    .shadowOpacity(opaCity: 0.5)
    .shadowOffset(offSetWith: 0, offSetHeignt: 4)
    .setAlpha(alpha: 1)
  .build()
  
  let tripImage = UIImageFactory()
  .build()
  
  let tripName = UILabelFactory(text: "")
    .textFonts(with: UIFont(name: "Montserrat-Bold", size: 16)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  let tripDates = UILabelFactory(text: "")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  let tripYear = UILabelFactory(text: "")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 13)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  let totalTripSpend = UILabelFactory(text: "Total Spend")
    .textFonts(with: UIFont(name: "Avenir-Medium", size: 12)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
  .build()
  
  let totalTripAmount = UILabelFactory(text: "")
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .textFonts(with: UIFont(name: "Montserrat-Bold", size: 26)!)
    .textAlignment(with: .center)
  .build()

  let closeButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Delete_Row")
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
        ContentView.addSubview(tripImage)
        tripImage.addSubview(tripName)
        tripImage.addSubview(tripDates)
        tripImage.addSubview(tripYear)
        tripImage.addSubview(totalTripSpend)
        tripImage.addSubview(totalTripAmount)
        addSubview(closeButton)
        
        bringSubviewToFront(ContentView)
        ContentView.bringSubviewToFront(tripImage)
        tripImage.bringSubviewToFront(tripName)
        tripImage.bringSubviewToFront(tripDates)
        tripImage.bringSubviewToFront(tripYear)
        tripImage.bringSubviewToFront(totalTripSpend)
        tripImage.bringSubviewToFront(totalTripAmount)
        bringSubviewToFront(closeButton)
        
        ContentView.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
        
        tripImage.layoutAnchor(top: ContentView.topAnchor, left: ContentView.leftAnchor, bottom: ContentView.bottomAnchor, right: ContentView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        tripName.layoutAnchor(top: tripImage.topAnchor, left: tripImage.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 25.0, paddingLeft: 25.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
        
        tripDates.layoutAnchor(top: tripName.bottomAnchor, left: tripName.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 2.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 19.0, enableInsets: true)
        
        tripYear.layoutAnchor(top: tripDates.bottomAnchor, left: tripName.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 2.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 16.0, enableInsets: true)
        
        totalTripSpend.layoutAnchor(top: nil, left: totalTripAmount.leftAnchor, bottom: totalTripAmount.topAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 2.0, paddingRight: 0.0, width: 0.0, height: 17.0, enableInsets: true)
        
        totalTripAmount.layoutAnchor(top: nil, left: tripImage.leftAnchor, bottom: tripImage.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 25.0, paddingBottom: 20.0, paddingRight: 0.0, width: 0.0, height: 23.0, enableInsets: true)
        
        closeButton.layoutAnchor(top: tripImage.topAnchor, left: nil, bottom: nil, right: tripImage.rightAnchor, centerX: nil, centerY: nil, paddingTop: 20.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 20.0, width: 25.0, height: 25.0, enableInsets: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
