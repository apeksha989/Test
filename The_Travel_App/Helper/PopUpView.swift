//
//  PopUpView.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 17/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import UIKit

protocol popUDelegate: class{
    func didTapButtonDismiss()
}

class PopUp : UIView {
    
    weak var delegate: popUDelegate? = nil
    
    var title: String?
    var message: String?
    var buttonTitle: String?
    var homeController: UIViewController?
    
    required init(title: String, message: String, buttonTitle: String, controller: UIViewController, frame: CGRect) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.homeController = controller
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    let imageview = UIImageFactory()
        .CornerRadious(radious: 5)
        .setImage(imageString: "PopUp_BGImage")
        .build()
    
    let homeLabel = UILabelFactory(text: "")
        .textAlignment(with: .center)
        .textColor(with: .white)
        .build()
    
    let currencyLabel = UILabelFactory(text: "")
        .textColor(with: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0))
        .textAlignment(with: .center)
        .numberOf(lines: 0)
        .lineBreaking(mode: .byWordWrapping)
        .build()
    
    let button        = UIButtonFactory(title: "")
        .setTitileColour(with: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0))
        .backgroundColour(with: .white)
        .textAlignmentButton(with: .center)
        .addTarget(self, action: #selector(didtabButton), for: .touchUpInside)
        .build()
    
    func setUpView(){
        layer.cornerRadius = 13.0
        backgroundColor    = .white
        
        additionalSubViews()
    }
    
    @objc func didtabButton(){
        print("tapped")
        delegate?.didTapButtonDismiss()
    }
    
    func additionalSubViews(){
        addSubview(imageview)
        imageview.addSubview(homeLabel)
        imageview.bringSubviewToFront(homeLabel)
        addSubview(currencyLabel)
        addSubview(button)
        homeLabel.text = title
        currencyLabel.text = message
        button.setTitle(buttonTitle, for: .normal)
        
        setUpLayoutViews()
    }
    
    func setUpLayoutViews(){
        
        imageview.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 67, enableInsets: true)
        
        homeLabel.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: imageview.centerXAnchor, centerY: imageview.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        currencyLabel.layoutAnchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, centerX: nil, centerY: centerYAnchor, paddingTop: 0.0, paddingLeft: 5.0, paddingBottom: 0.0, paddingRight: 5.0, width: 0.0, height: 0.0, enableInsets: true)
        
        button.layoutAnchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, centerX: centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 100, height: 70.0, enableInsets: true)
    }
}
