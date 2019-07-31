//
//  CategoryDropDownViewCell.swift
//  Haggle
//
//  Created by Anil Kumar on 25/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class CategoryDropDownViewCell: UITableViewCell {
    
    let cardView = UIViewFactory()
        .clipToBounds(Bool: true)
        .masksToBounds(Bool: false)
        .shadowColor(color: UIColor(red: 0.85, green: 0.89, blue: 0.91, alpha: 0.50))
        .shadowOpacity(opaCity: 0.7)
        .shadowRadious(with: 2)
        .shadowOffset(offSetWith: 5, offSetHeignt: 5)
        .backgroundColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
        .setAlpha(alpha: 1)
        .build()
    
    let categoryName = UILabelFactory(text: "")
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 16)!)
        .textColor(with: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1))
        .textAlignment(with: .left)
        .build()
    
    let categoryIcons = UIImageFactory()
        .build()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cardView)
        cardView.addSubview(categoryName)
        cardView.addSubview(categoryIcons)
        
        cardView.bringSubviewToFront(categoryName)
        cardView.bringSubviewToFront(categoryIcons)
        
        setUpConstraintsToAttributes()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraintsToAttributes(){
        
        cardView.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 5.0, paddingBottom: 0.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
        
        categoryIcons.layoutAnchor(top: nil, left: cardView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: cardView.centerYAnchor , paddingTop: 0.0, paddingLeft: 20.0, paddingBottom: 0.0, paddingRight: 0.0, width: 24.0, height: 24.0, enableInsets: true)
        
        categoryName.layoutAnchor(top: cardView.topAnchor, left: categoryIcons.rightAnchor, bottom: cardView.bottomAnchor, right: cardView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 17.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
    }
}
