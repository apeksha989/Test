//
//  BudgetCategoriesCell.swift
//  Haggle
//
//  Created by Anil Kumar on 23/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class BudgetCategoriesCell: UITableViewCell {
  
  lazy var progressView     = GradientProgressBar()
  
  let categoryTitle = UILabelFactory(text: "")
    .textAlignment(with: .left)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 9)!)
    .textColor(with: UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1))
  .build()
  
  let categoryBudget = UILabelFactory(text: "")
    .textAlignment(with: .right)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 9)!)
    .textColor(with: UIColor(red: 0.01, green: 0.39, blue: 0.66, alpha: 1))
  .build()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  override func prepareForReuse() {
    progressView.setProgress(0.0, animated: false)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
//    addSubview(emptyLabel)
    addSubview(categoryTitle)
    addSubview(categoryBudget)
    addSubview(progressView)
    
//    progressView.setProgress(0, animated: true)
    
    progressView.cornerRadius = 8.0
    progressView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1)
    progressView.trackTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1)
    
    setUpLayoutConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpLayoutConstraints(){
//    emptyLabel.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: centerXAnchor, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: contentView.frame.width, height: 20, enableInsets: true)
    
    categoryTitle.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 10.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 100.0, height: 12.0, enableInsets: true)
    
    categoryBudget.layoutAnchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 10.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 100.0, height: 12.0, enableInsets: true)
    
    progressView.layoutAnchor(top: categoryTitle.bottomAnchor, left: categoryTitle.leftAnchor, bottom: nil, right: categoryBudget.rightAnchor, centerX: nil, centerY: nil, paddingTop: 5.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 15.0, enableInsets: true)
  }
  
}
