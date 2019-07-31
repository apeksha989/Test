//
//  WalletMainViewCell.swift
//  Haggle
//
//  Created by Anil Kumar on 22/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class WalletMainViewCell: UITableViewCell {
    
    
    let walletCardview = UIViewFactory()
        .clipToBounds(Bool: true)
        .masksToBounds(Bool: false)
        .shadowColor(color: UIColor(red: 0.56, green: 0.56, blue: 0.56, alpha: 0.50))
        .shadowOffset(offSetWith: 0, offSetHeignt: 2)
        .shadowOpacity(opaCity: 0.5)
        .setAlpha(alpha: 1)
        .build()
    
    let homeCurrencyAmount = UILabelFactory(text: "")
        .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 18)!)
        .textAlignment(with: .left)
        .adjustFontSize(Bool: true)
        .build()
    
    
    let homeCurrency = UILabelFactory(text: "")
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 7)!)
        .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
        .build()
    
    
    let totalBudgetAmount = UILabelFactory(text: "")
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 25)!)
        .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
        .textAlignment(with: .left)
        .adjustFontSize(Bool: true)
        .build()
    
    
    let totalBudgetLabel = UILabelFactory(text: "")
        .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 7)!)
        .build()
    
    
    let walletItemDetail = UILabelFactory(text: "")
        .numberOf(lines: 0)
        .textAlignment(with: .left)
        .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 13)!)
        .build()
    
    let walletTitle = UILabelFactory(text: "")
        .textAlignment(with: .left)
        .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 21)!)
        .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
        .build()
    
    let walletMenu = UIImageFactory()
        .build()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(walletCardview)
        walletCardview.addSubview(walletMenu)
        walletMenu.addSubview(walletTitle)
        walletMenu.addSubview(walletItemDetail)
        walletMenu.addSubview(totalBudgetLabel)
        walletMenu.addSubview(totalBudgetAmount)
        walletMenu.addSubview(homeCurrency)
        walletMenu.addSubview(homeCurrencyAmount)
        
        walletCardview.bringSubviewToFront(walletMenu)
        walletMenu.bringSubviewToFront(walletTitle)
        walletMenu.bringSubviewToFront(walletItemDetail)
        walletMenu.bringSubviewToFront(totalBudgetLabel)
        walletMenu.bringSubviewToFront(totalBudgetAmount)
        walletMenu.bringSubviewToFront(homeCurrency)
        walletMenu.bringSubviewToFront(homeCurrencyAmount)
        
        walletCardview.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
        
        walletMenu.layoutAnchor(top: walletCardview.topAnchor, left: walletCardview.leftAnchor, bottom: walletCardview.bottomAnchor, right: walletCardview.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        walletTitle.layoutAnchor(top: walletCardview.topAnchor, left: walletCardview.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 35.0, paddingLeft: 30.0, paddingBottom: 0.0, paddingRight: 0.0, width: 130.0, height: 28.0, enableInsets: true)
        
        walletItemDetail.layoutAnchor(top: walletTitle.bottomAnchor, left: walletTitle.leftAnchor, bottom: nil, right: totalBudgetLabel.leftAnchor, centerX: nil, centerY: nil, paddingTop: 10.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 50.0, enableInsets: true)
        
        totalBudgetLabel.layoutAnchor(top: walletCardview.topAnchor, left: nil, bottom: nil, right: walletCardview.rightAnchor, centerX: nil, centerY: nil, paddingTop: 50.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 60.0, width: 47.0, height: 10.0, enableInsets: true)
        
        totalBudgetAmount.layoutAnchor(top: totalBudgetLabel.bottomAnchor, left: totalBudgetLabel.leftAnchor, bottom: nil, right: walletMenu.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 32.0, enableInsets: true)
        
        homeCurrency.layoutAnchor(top: totalBudgetAmount.bottomAnchor, left: totalBudgetAmount.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 57.0, height: 10.0, enableInsets: true)
        
        homeCurrencyAmount.layoutAnchor(top: homeCurrency.bottomAnchor, left: homeCurrency.leftAnchor, bottom: nil, right: walletMenu.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 23.0, enableInsets: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
