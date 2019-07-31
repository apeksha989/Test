//
//  WalletDocumentsController.swift
//  Haggle
//
//  Created by Anil Kumar on 22/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class WalletDocumentsController: UIViewController {
  
  lazy var documentCollectionView    = documentCollectionViewClass(controller: self)
    
  let walletDocumentTopView = UIViewFactory()
  .build()
  
  let walletDocumentTitle = UILabelFactory(text: "Saved")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
  .build()
  
  let walletDocumentBack = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Black_Back_Btn")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
  .build()
  
  let walletDocumentEdit = UIButtonFactory(title: "Edit")
    .setTitileColour(with: UIColor(red: 0.82, green: 0.01, blue: 0.11, alpha: 1))
    .textFonts(with: UIFont(name: "Avenir-Medium", size: 14)!)
    .addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
  .build()

  
  let walletDocumentDelete = UIButtonFactory(title: "Delete")
    .setTitileColour(with: UIColor(red: 0.82, green: 0.01, blue: 0.11, alpha: 1))
    .textFonts(with: UIFont(name: "Avenir-Medium", size: 14)!)
    .addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
  .build()
  
  var arrSelectedIndex = [IndexPath]() // This is selected cell Index array
  var arrSelectedIndexInt = [Int]()
  
  var dateValue : [String] = []
  
  var imageValue : [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------WalletDocumentsController------------>😀")
    if let imageArrayValue = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "WalletDocImageArray") as? [UIImage] {
      UserDetails.imageArray = imageArrayValue
    }

    if let dateArrayValue = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "WalletDocDateArray")  as? [String] {
      UserDetails.dateArray = dateArrayValue
    }
    
    documentCollectionView.delegate = self
    documentCollectionView.dataSource = self
    documentCollectionView.backgroundColor = .white
    documentCollectionView.allowsMultipleSelection = true
    
    walletDocumentDelete.isHidden = true
    
    setUpCellRegistration()
    setUpLayoutViews()
  }
  override func viewWillAppear(_ animated: Bool) {
    walletDocumentDelete.isHidden = true
  }
  
  func setUpCellRegistration(){
    documentCollectionView.register(DocumentCollectionCell.self, forCellWithReuseIdentifier: "DocumentCollectionCell")
  }
  
  @objc func backButtonTapped(){
    popOrPushToViewController("WalletMainController")
  }
  
  @objc func editButtonTapped(){
    walletDocumentEdit.isHidden = true
    walletDocumentDelete.isHidden = false
  }
  
  @objc func deleteButtonTapped(){
    walletDocumentEdit.isHidden = false
    walletDocumentDelete.isHidden = true
    
        UserDetails.imageArray = UserDetails.imageArray
          .enumerated()
          .filter { !arrSelectedIndexInt.contains($0.offset) }
          .map { $0.element }
        
        UserDetails.dateArray = UserDetails.dateArray
          .enumerated()
          .filter { !arrSelectedIndexInt.contains($0.offset) }
          .map { $0.element }

    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.imageArray, storeType: "WalletDocImageArray")
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.dateArray, storeType: "WalletDocDateArray")
    arrSelectedIndexInt.removeAll()
    documentCollectionView.reloadData()

  }
  
  func setUpLayoutViews(){
    view.addSubview(walletDocumentTopView)
    walletDocumentTopView.addSubview(walletDocumentTitle)
    walletDocumentTopView.addSubview(walletDocumentBack)
    walletDocumentTopView.addSubview(walletDocumentEdit)
    walletDocumentTopView.addSubview(walletDocumentDelete)
    view.addSubview(documentCollectionView)
    
    setUpConstraintsToAttributes()
  }
  
  func setUpConstraintsToAttributes(){
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      walletDocumentTopView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)
      
      documentCollectionView.layoutAnchor(top: walletDocumentTopView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 30.0, paddingLeft: 0.0, paddingBottom: 20.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    default:
      walletDocumentTopView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
      
      documentCollectionView.layoutAnchor(top: walletDocumentTopView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 30.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    }
    walletDocumentTitle.layoutAnchor(top: nil, left: nil, bottom: walletDocumentTopView.bottomAnchor, right: nil, centerX: walletDocumentTopView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
    
    walletDocumentBack.layoutAnchor(top: nil, left: walletDocumentTopView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: walletDocumentTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
    
    walletDocumentEdit.layoutAnchor(top: nil, left: nil, bottom: nil, right: walletDocumentTopView.rightAnchor, centerX: nil, centerY: walletDocumentTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 24.0, width: 30.0, height: 20.0, enableInsets: true)
    
    walletDocumentDelete.layoutAnchor(top: nil, left: nil, bottom: nil, right: walletDocumentTopView.rightAnchor, centerX: nil, centerY: walletDocumentTitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 24.0, width: 43.0, height: 20.0, enableInsets: true)
  }
}

extension WalletDocumentsController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 152.0, height: 174.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 10.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 35.0
  }
}

extension WalletDocumentsController: UICollectionViewDataSource{
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if !UserDetails.imageArray.isEmpty{
      collectionView.setEmptyMessage("")
      return UserDetails.imageArray.count
    }else{
      collectionView.setEmptyMessage("No photos")
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCollectionCell", for: indexPath) as! DocumentCollectionCell
    print(UserDetails.imageArray)
    print(UserDetails.dateArray)
    cell.documentImage.image = UserDetails.imageArray[indexPath.row]
    cell.documentCreatedDate.text = UserDetails.dateArray[indexPath.row]
    cell.layer.borderWidth = 0.0
    cell.layer.borderColor = UIColor.clear.cgColor
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if walletDocumentDelete.isHidden == false {
        
      if arrSelectedIndex.contains(indexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0.0
        cell?.layer.borderColor = UIColor.clear.cgColor
        arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
        arrSelectedIndexInt = arrSelectedIndexInt.filter { $0 != indexPath.row }
      }
      else {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 5.0
        cell?.layer.borderColor = UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1).cgColor
        arrSelectedIndex.append(indexPath)
        arrSelectedIndexInt.append(indexPath.row)
      }
      print(arrSelectedIndexInt)
      print(arrSelectedIndex)
    }else{
       UserDetails.selectedImage = UserDetails.imageArray[indexPath.row]
       UserDetails.selectedDate = UserDetails.dateArray[indexPath.row]
      arrSelectedIndex.removeAll()
      arrSelectedIndexInt.removeAll()
      popOrPushToViewController("DocumentViewController")
    }
  }
}
