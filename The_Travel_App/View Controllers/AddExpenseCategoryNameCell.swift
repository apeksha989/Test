//
//  AddExpenseCategoryNameCell.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 05/07/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class AddExpenseCategoryNameCell: UITableViewCell, UITextFieldDelegate {

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
    .spellCheckingType(with: .no)
    .autocorrectionType(with: .no)
    .setFont(font: UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(color: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1))
    .build()
  
  
  let numberToolbar         = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
  var categoryName = String()
  
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
    
    numberToolbar.items = [
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTabDone))]
    numberToolbar.sizeToFit()
    expenseTextField.adjustsFontSizeToFitWidth = true
    expenseTextField.delegate = self
    expenseTextField.inputAccessoryView = numberToolbar
    
    addSubview(cardView)
    cardView.addSubview(expenseTextField)
    
    cardView.bringSubviewToFront(expenseTextField)
    
    setUpConstraintsToAttributes()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpConstraintsToAttributes(){
    
    cardView.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
    
    expenseTextField.layoutAnchor(top: cardView.topAnchor, left: cardView.leftAnchor, bottom: cardView.bottomAnchor, right: cardView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 35.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    expenseTextField.resignFirstResponder()
    return true
  }
  
  @objc func didTabDone(){
    categoryName = expenseTextField.text!
    expenseTextField.resignFirstResponder()
  }

}
