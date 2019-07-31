//
//  TransactionsViewCell.swift
//  Haggle
//
//  Created by Anil Kumar on 19/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class TransactionsViewCell: UITableViewCell {
  
  let ContentView = UIViewFactory()
    .clipToBounds(Bool: true)
    .masksToBounds(Bool: false)
    .shadowColor(color: UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 0.50))
    .shadowOpacity(opaCity: 0.5)
    .shadowOffset(offSetWith: 0, offSetHeignt: 3)
    .cornerRadious(value: 10)
    .backgroundColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .setAlpha(alpha: 1)
    .build()
  
  let transactionName = UILabelFactory(text: "Starbucks")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
    .build()
  
  let transactionAmount = UILabelFactory(text: "")
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
    .textAlignment(with: .right)
    .build()
  
  let expirydays = UILabelFactory(text: "1 day ago")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 8)!)
    .textColor(with: UIColor(red: 0.70, green: 0.70, blue: 0.70, alpha: 1))
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
        addSubview(transactionName)
        addSubview(transactionAmount)
        addSubview(expirydays)
       
        bringSubviewToFront(ContentView)
        bringSubviewToFront(transactionName)
        bringSubviewToFront(transactionAmount)
        bringSubviewToFront(expirydays)
        transactionAmount.textAlignment = .center
        ContentView.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
        
        transactionName.layoutAnchor(top: ContentView.topAnchor, left: ContentView.leftAnchor, bottom: nil, right: transactionAmount.leftAnchor, centerX: nil, centerY: nil, paddingTop: 13.0, paddingLeft: 24.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
        
        expirydays.layoutAnchor(top: transactionName.bottomAnchor, left: transactionName.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 42.0, height: 12.0, enableInsets: true)
        
        transactionAmount.layoutAnchor(top: nil, left: nil, bottom: nil, right: ContentView.rightAnchor, centerX: nil, centerY: ContentView.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 15.0, width: frame.size.width/3, height: 20, enableInsets: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
