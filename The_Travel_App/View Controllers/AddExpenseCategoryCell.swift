//
//  AddExpenseCategoryCell.swift
//  Haggle
//
//  Created by Anil Kumar on 25/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class AddExpenseCategoryCell: UITableViewCell, UITextFieldDelegate {

  let cardView = UIViewFactory()
    .clipToBounds(Bool: true)
    .masksToBounds(Bool: false)
    .shadowColor(color: UIColor(red: 0.85, green: 0.89, blue: 0.91, alpha: 0.50))
    .shadowOpacity(opaCity: 0.7)
    .shadowRadious(with: 2)
    .shadowOffset(offSetWith: 5, offSetHeignt: 5)
    .cornerRadious(value: 6)
    .borderColor(color: UIColor(red: 0.86, green: 0.87, blue: 0.89, alpha: 0.30))
    .borderWith(value: 1)
    .backgroundColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .setAlpha(alpha: 1)
  .build()
  
  let expenseTextField = UITextFieldFactory()
    .setFont(font: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(color: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1))
  .build()
  
  let dropDown = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Drop_Down")
  .build()
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        expenseTextField.delegate = self
        
        addSubview(cardView)
        cardView.addSubview(expenseTextField)
        cardView.addSubview(dropDown)
        
        cardView.bringSubviewToFront(expenseTextField)
        cardView.bringSubviewToFront(dropDown)
        
        setUpConstraintsToAttributes()
        
    }  
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraintsToAttributes(){
        
        cardView.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 5.0, paddingBottom: 0.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
        
        expenseTextField.layoutAnchor(top: cardView.topAnchor, left: cardView.leftAnchor, bottom: cardView.bottomAnchor, right: dropDown.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 35.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        dropDown.layoutAnchor(top: nil, left: nil, bottom: nil, right: cardView.rightAnchor, centerX: nil, centerY: cardView.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 15.0, width: 15.0, height: 9.0, enableInsets: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        expenseTextField.resignFirstResponder()
        return true
    }
  func textFieldDidBeginEditing(_ textField: UITextField) {
    expenseTextField.resignFirstResponder()
  }
}
