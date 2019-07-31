//
//  EditeDateCell.swift
//  Haggle
//
//  Created by Anil Kumar on 11/05/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class EditeDateCell: UITableViewCell, UITextFieldDelegate {
  
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
  
  let tripDates = UILabelFactory(text: "")
    .textAlignment(with: .left)
    .textFonts(with:  UIFont(name: "Montserrat-Medium", size: 16)!)
    .textColor(with: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1))
  .build()
  
  let dropDownButton = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Drop_Down")
  .build()
  
  var controller = EditeTripController()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @objc func dropDownTapped(){
    let calendar = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
    calendar.delegate = controller
    calendar.minimumDate = Date()
    calendar.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
    calendar.selectedStartDate = Date()
    calendar.selectedEndDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    calendar.selectedColor = UIColor(red: 0.00, green: 0.82, blue: 1.00, alpha: 1)
    calendar.titleText = "Select Trip Dates"
    let navigationController = UINavigationController(rootViewController: calendar)
    controller.navigationController?.present(navigationController, animated: true, completion: nil)
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return false
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(ContentView)
    ContentView.addSubview(tripDates)
    ContentView.addSubview(dropDownButton)
    
    bringSubviewToFront(ContentView)
    ContentView.bringSubviewToFront(tripDates)
    ContentView.bringSubviewToFront(dropDownButton)
    
    ContentView.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
    
    tripDates.layoutAnchor(top: ContentView.topAnchor, left: ContentView.leftAnchor, bottom: ContentView.bottomAnchor, right: dropDownButton.leftAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 30.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    
    dropDownButton.layoutAnchor(top: nil, left: nil, bottom: nil, right: ContentView.rightAnchor, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 15.0, width: 15.0, height: 9.0, enableInsets: true)
    
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
