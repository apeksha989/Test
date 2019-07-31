//
//  WalletIdController.swift
//  Haggle
//
//  Created by Anil Kumar on 22/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//
import UIKit
import IDPalSDK

var IDPalimagData         : [[String:Data]]           = []
var IDPalUserData         : [[String:Data]]           = []

class WalletIdController: UIViewController {

  lazy var walletIdTable : UITableView = {
    let tableview = UITableView()
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  let walletIdEdit = UIButtonFactory(title: "Edit")
  .setTitileColour(with: UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1))
  .textFonts(with: UIFont(name: "Avenir-Medium", size: 14)!)
  .addTarget(self, action: #selector(editeTapped), for: .touchUpInside)
  .build()
  
  let walletIdDone = UIButtonFactory(title: "Done")
    .setTitileColour(with: UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1))
    .textFonts(with: UIFont(name: "Avenir-Medium", size: 14)!)
    .addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    .build()
  
  
  let createIDButton = UIButtonFactory(title: "CREATE ID")
    .setTitileColour(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 14)!)
    .addTarget(self, action: #selector(createIDButtontapped), for: .touchUpInside)
    .build()
  
  let walletIdTopView = UIViewFactory()
    .build()
  
  let walletIdtitle = UILabelFactory(text: "ID".uppercased())
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
    .build()
  
  let walletIdBack = UIButtonFactory(title: "")
    .setBackgroundImage(image: "Black_Back_Btn")
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    .build()
  
    var BoolFlag = true
    var IDPalOpenFlag = false
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        walletIdDone.isHidden = true
        walletIdEdit.isHidden = false
      
        walletIdTable.dataSource = self
        walletIdTable.delegate = self
        walletIdTable.showsVerticalScrollIndicator = false
        walletIdTable.tableFooterView = UIView(frame: .zero)

      
        setUpCellRegistration()
        setUpLayoutViews()
      
    }
  override func viewWillAppear(_ animated: Bool) {
    IDPalOpenFlag = false
    if !IDPalUserData.isEmpty{
      walletIdTable.reloadData()
    }
  }
  
  
  @objc func editeTapped(){
    walletIdDone.isHidden = false
    walletIdEdit.isHidden = true
  }
  
  @objc func doneTapped() {
    walletIdDone.isHidden = true
    walletIdEdit.isHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    walletIdDone.isHidden = true
    walletIdEdit.isHidden = false
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradiantViewButton(createIDButton)
    }
    
    func setUpCellRegistration(){
        walletIdTable.register(WalletIDViewCell.self, forCellReuseIdentifier: "WalletIDViewCell")
    }
    
    @objc func backButtonTapped(){
        popOrPushToViewController("WalletMainController")
    }
    
    @objc func createIDButtontapped(){
      if BoolFlag == false {
        _ = IDPalSDKController.loadIDPal(withStartScreen: false, andConfirmationScreen: true, andParentViewController: self)
      }else{
        createIDButton.setTitle("", for: .normal)
        createIDButton.loadingIndicator(show: true)
        _ = IDPalSDKController.initIDPalSDK(withLicenseKey: Key.IDPal.LicenseKey, andUuid: Key.IDPal.UUID, delegate: self)
      }
    }
    func setUpLayoutViews(){
        view.addSubview(walletIdTopView)
        walletIdTopView.addSubview(walletIdtitle)
        walletIdTopView.addSubview(walletIdBack)
        walletIdTopView.addSubview(walletIdEdit)
        walletIdTopView.addSubview(walletIdDone)
        view.addSubview(createIDButton)
        view.addSubview(walletIdTable)
        
        walletIdTopView.bringSubviewToFront(walletIdtitle)
        walletIdTopView.bringSubviewToFront(walletIdBack)
        walletIdTopView.bringSubviewToFront(walletIdEdit)
        walletIdTopView.bringSubviewToFront(walletIdDone)
        setUpConstraintsToAttributes()
    }
    
    func setUpConstraintsToAttributes(){
        switch UIDevice().type {
        case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
            walletIdTopView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42 + 20.0, enableInsets: true)
            
            createIDButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 63.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
        default:
            walletIdTopView.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: view.frame.size.height/10.42, enableInsets: true)
            
            createIDButton.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 43.0, paddingRight: 0.0, width: view.frame.size.width/1.17, height: 56.0, enableInsets: true)
        }
        walletIdtitle.layoutAnchor(top: nil, left: nil, bottom: walletIdTopView.bottomAnchor, right: nil, centerX: walletIdTopView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
      
        walletIdBack.layoutAnchor(top: nil, left: walletIdTopView.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: walletIdtitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
        
        walletIdEdit.layoutAnchor(top: nil, left: nil, bottom: nil, right: walletIdTopView.rightAnchor, centerX: nil, centerY: walletIdtitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 24.0, width: 30.0, height: 20.0, enableInsets: true)
      
        walletIdDone.layoutAnchor(top: nil, left: nil, bottom: nil, right: walletIdTopView.rightAnchor, centerX: nil, centerY: walletIdtitle.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 24.0, width: 50.0, height: 20.0, enableInsets: true)
        
        walletIdTable.layoutAnchor(top: walletIdTopView.bottomAnchor, left: view.leftAnchor, bottom: createIDButton.topAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 50.0, paddingLeft: 13.0, paddingBottom: 10.0, paddingRight: 13.0, width: 0.0, height: 0.0, enableInsets: true)
    }
}

extension WalletIdController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension WalletIdController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if !IDPalUserData.isEmpty{
        tableView.setEmptyMessage("")
        return IDPalUserData.count
      }else{
        walletIdDone.isHidden = true
        walletIdEdit.isHidden = false
        tableView.setEmptyMessage("You have not verified any ID documents as of yet")
        return 0
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletIDViewCell", for: indexPath) as! WalletIDViewCell
      
      let Allvalue = IDPalUserData[indexPath.row]
      
      for (key, Value) in Allvalue {
        cell.idImage.image = UIImage(data: Value)
        cell.idName.text = key
        cell.idNavigation.image = UIImage(named: "next")
      }

      cell.selectionStyle = .none
      return cell
    }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if !walletIdEdit.isHidden{
      let Allvalue = IDPalUserData[indexPath.row]
      for (key, Value) in Allvalue {
        UserDetails.selectedImage = UIImage(data: Value)!
        popOrPushToViewController("DocumentViewController")
      }
    }
    
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if walletIdEdit.isHidden {
     return true
    }else{
     return false
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      print(indexPath.row)
      print(IDPalUserData[indexPath.row])
      IDPalUserData.remove(at: indexPath.row)
      UserDefaults.standard.set(IDPalUserData, forKey: "IDPalDocuments")
//      StrongBoxController.sharedInstance.storeUserDefault(data: IDPalUserData, storeType: "IDPalDocuments")
      tableView.deleteRows(at: [indexPath], with: .automatic)
      self.perform(#selector(reloadTable), with: nil, afterDelay: 1)
    }
  }
  @objc func reloadTable() {
    DispatchQueue.main.async {
      self.walletIdTable.reloadData()
    }
  }
  
}


extension WalletIdController : IDPalApplicationDelegate{

  func didFinishPreloading(_ result: Bool, withError message: String!, withProcess steps: [AnyHashable : Any]!, andDataFields fields: [Any]!) {
    if !(result){
      self.showConfirmAlert(title: "Failed", message: "", buttonTitle: "OK", buttonStyle: .default) { [weak self](action) in
        self?.createIDButton.loadingIndicator(show: false)
        self?.createIDButton.setTitle("CREATE ID", for: .normal)
      }
    }else{
      if IDPalOpenFlag == false{
        IDPalOpenFlag = true
        BoolFlag = false
        self.createIDButton.loadingIndicator(show: false)
        self.createIDButton.setTitle("CREATE ID", for: .normal)        
        _ = IDPalSDKController.loadIDPal(withStartScreen: false, andConfirmationScreen: true, andParentViewController: self)
      }
    }
  }

  func didComplete(_ step: String!, withResult result: String!, andError message: String!, submissionID: NSNumber!, personalInformation dataFields: [AnyHashable : Any]!, images imageData: [AnyHashable : Any]!, isLastStep lastStep: Bool) {
    
    if step == CapturedDocument.paperlicense.name{
      if let frontImage = imageData["frontImage"] as? Data{
//          let image = UIImage(data: frontImage)
          let updateValue = [step!:frontImage]
          IDPalimagData.append(updateValue)
      }
    }

    if step == CapturedDocument.passport.name{
     appendingPassportOrDl(imageData, dataFields, step)
    }

    if step == CapturedDocument.nationalId.name{
      appendingPassportOrDl(imageData, dataFields, step)
    }

    if step == CapturedDocument.additional.name{
      if let frontImage = imageData["backImage"] as? Data{
//        let image = UIImage(data: frontImage)
        let updateValue = [step!:frontImage]
        IDPalimagData.append(updateValue)
      }
    }


    if step == CapturedDocument.utilityImg.name{
      if let frontImage = imageData["frontImage"] as? Data{
//        let image = UIImage(data: frontImage)
        let updateValue = [step!:frontImage]
        IDPalimagData.append(updateValue)
      }
    }
    
    if lastStep {
      
      let value = IDPalimagData.map {$0.values}
      
      for i in IDPalimagData {
        if !IDPalUserData.contains(i){
            IDPalUserData.append(i)
        }
      }
      
      UserDefaults.standard.set(IDPalUserData, forKey: "IDPalDocuments")
    }
    
  }


  func appendingPassportOrDl(_ Data: [AnyHashable : Any]!, _ FnameAndLname: [AnyHashable : Any]!,_ DocumentName: String){
    if let frontImage = Data["frontImage"] as? Data{
      var fName = String()
      var LName = String()
      if let firstName = FnameAndLname["firstName"] as? String{
        fName = firstName
      }
      if let Lastname = FnameAndLname["lastName"] as? String {
        LName = Lastname
      }
      let FinalName = "\(fName) \(LName) \(DocumentName)"
      let updateValue = [FinalName:frontImage]
      IDPalimagData.append(updateValue)
    }
  }

  private func presentViewController(alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: flag, completion: completion)
  }

  func warningAlert(title: String, message: String ){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:  { (action) -> Void in
    }))
    presentViewController(alert: alert, animated: true, completion: nil)
  }

}

enum CapturedDocument {
  case paperlicense , passport, nationalId  , additional ,utilityImg,utilityImg2,utilityImg3
  var name:String {
    switch self {
    case .paperlicense: return "OldPaperLicense"
    case .passport: return "Passport"
    case .nationalId: return "nationalID"
    case .additional: return "AdditionalDocument"
    case .utilityImg:return "ProofOfAddress"
    case .utilityImg2:return "ProofOfAddress"
    case .utilityImg3:return "ProofOfAddress"
    }
  }
}

