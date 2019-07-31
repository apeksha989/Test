//
//  SocialMediaViewController.swift
//  Haggle
//
//  Created by Anil Kumar on 29/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class SocialMediaViewController: UIViewController {
  
  lazy var dimView               = UIView(frame: UIScreen.main.bounds)
  var loginManager               = LoginManager()
  var GroupedStatsStackView      = UIStackView()
  
  private let appNameLabel       = UILabelFactory(text: "The Travel App")
    .numberOf(lines: 0)
    .textColor(with:  UIColor.white)
    .textFonts(with: UIFont(name: "SignPainter-HouseScript", size: 50.0)!)
    .registerSDK(Register: "SignPainter-HouseScript", type: "ttf")
    .build()
  
  private let termsLabel         = UILabelFactory(text: "By registering on The Travel App you agree to our terms and conditions")
    .numberOf(lines: 0)
    .textColor(with:  UIColor.white)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 13.0)!)
    .registerSDK(Register: "Montserrat-Regular", type: "otf")
    .build()
  
  private let orLabel           = UILabelFactory(text:  "Or")
    .numberOf(lines: 0)
    .textColor(with:  UIColor.white)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 9.0)!)
    .registerSDK(Register: "Montserrat-Regular", type: "otf")
    .build()
  
  private let registerLabel      = UILabelFactory(text:  "Register now via your social media accounts")
    .numberOf(lines: 0)
    .textColor(with:  UIColor.white)
    .textFonts(with: UIFont(name: "Montserrat-Regular", size: 12.0)!)
    .registerSDK(Register: "Montserrat-Regular", type: "otf")
    .build()
  
  private let skipButton         = UIButtonFactory(title: "Skip For Now", style: .normal)
    .backgroundColour(with: UIColor.clear)
    .textAlignmentButton(with: NSTextAlignment.center)
    .setTitileColour(with: UIColor.white)
    .textFonts(with: UIFont(name: "Montserrat-Medium", size: 18.0)!)
    .registerSDK(Register: "Montserrat-Medium", type: "otf")
    .addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    .build()
  
   private let fbButton = UIButtonFactory(title: "", style: .normal)
    .setBackgroundImage(image: "facebookIcon")
    .addTarget(self, action: #selector(fbButtontapped), for: .touchUpInside)
    .build()
  
   private let twitterButton = UIButtonFactory(title: "", style: .normal)
    .setBackgroundImage(image: "twitterIcon")
    .addTarget(self, action: #selector(twitterButtonTapped), for: .touchUpInside)
    .build()
  
   private let googleButton = UIButtonFactory(title: "", style: .normal)
    .setBackgroundImage(image: "googleIcon")
    .addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
    .build()
  
  
  //MARK: ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------SocialMediaViewController------------>😀")
    termsLabel.lineBreakMode = .byWordWrapping
    termsLabel.numberOfLines = 3
    loginManager.loginBehavior = .browser
    let arry = [fbButton,twitterButton,googleButton]
    GroupedStatsStackView = UIStackViewFactory(buttons: arry)
      .build()
    
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    view.addSubview(dimView)
    view.addSubview(appNameLabel)
    view.addSubview(registerLabel)
    view.addSubview(GroupedStatsStackView)
    view.addSubview(orLabel)
    view.addSubview(skipButton)
    view.addSubview(termsLabel)
    
    bringSubView(label: appNameLabel)
    bringSubView(label: registerLabel)
    bringSubView(stackview: GroupedStatsStackView)
    bringSubView(label: orLabel)
    bringSubView(button: skipButton)
    bringSubView(label: termsLabel)
    
    setUpConstraintsToAttributes()
    
    fbButton.widthAnchor.constraint(equalToConstant: 63.0).isActive = true
    fbButton.heightAnchor.constraint(equalToConstant: 63.0).isActive = true
    
    twitterButton.widthAnchor.constraint(equalToConstant: 63.0).isActive = true
    twitterButton.heightAnchor.constraint(equalToConstant: 63.0).isActive = true
    
    googleButton.widthAnchor.constraint(equalToConstant: 63.0).isActive = true
    googleButton.heightAnchor.constraint(equalToConstant: 63.0).isActive = true
    
    navigationController?.setNavigationBarHidden(true, animated: true)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let bun = Bundle(identifier: BudleIdentifire.Identifire)
    if let urlPath = bun?.path(forResource: "test", ofType: "mp4"){
      VideoBackground.shared.play(view: view, url: URL(fileURLWithPath: urlPath))
    }else{
      try? VideoBackground.shared.play(view: view, videoName: "test", videoType: "mp4")
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    Networking.destroy()
  }
  
  deinit {
    Networking.destroy()
    print("☺️ Deinitialization SocialMediaViewController --->")
  }
}


//MARK: Google SignIn Delegates                                                          
extension SocialMediaViewController: GIDSignInUIDelegate,GIDSignInDelegate{
  
  //  MARK:Google SignIn Delegate
     // added public changes made by Apeksha
public func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
    present(self, animated: true, completion: nil)
  }
  
  //  completed sign In
     // added public changes made by Apeksha
 public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if (error == nil) {
      let fullName = user.profile.name
      guard let profileName = fullName else {return}
      if user.profile.hasImage{
        let imageURL = user.profile.imageURL(withDimension: 200).absoluteString
        print(imageURL)
        DispatchQueue.main.async { [weak self] in
         //   guard let self = self else { return }Changes made by Apeksha
          guard let `self` = self else { return }
          Networking.sharedInstance.proccessImage(imageURL, profileName: profileName)
          self.popOrPushToViewController("WelcomeScreen")
        }
      }      
    }
  }
}

extension SocialMediaViewController{
  
  func setUpConstraintsToAttributes() {
    
    appNameLabel.layoutAnchor(top: view.topAnchor, left: nil,
                              bottom: nil,right: nil,
                              centerX: view.centerXAnchor, centerY: nil,
                              paddingTop: view.frame.size.height/3-35.5,
                              paddingLeft: 0.0, paddingBottom: 0.0,
                              paddingRight: 0.0, width: 250, height: 50, enableInsets: true)
    
    registerLabel.layoutAnchor(top: nil, left: nil,
                               bottom: GroupedStatsStackView.topAnchor, right: nil,
                               centerX: GroupedStatsStackView.centerXAnchor, centerY: nil,
                               paddingTop: 0.0, paddingLeft: 0.0,
                               paddingBottom: 30, paddingRight: 0.0,
                               width: view.frame.size.width, height: 13, enableInsets: true)
    
    GroupedStatsStackView.layoutAnchor(top: nil, left: nil,
                                       bottom: orLabel.topAnchor, right: nil,
                                       centerX: view.centerXAnchor, centerY: nil,
                                       paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 25,
                                       paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    
    orLabel.layoutAnchor(top: nil, left: nil,
                         bottom: skipButton.topAnchor, right: nil,
                         centerX: skipButton.centerXAnchor, centerY: nil,
                         paddingTop: 0.0, paddingLeft: 0.0,
                         paddingBottom: 45, paddingRight: 0.0,
                         width: 15, height: 13, enableInsets: true)
    
    skipButton.layoutAnchor(top: nil, left: nil,
                            bottom: termsLabel.topAnchor, right: nil,
                            centerX: termsLabel.centerXAnchor, centerY: nil,
                            paddingTop: 0.0, paddingLeft: 0.0,
                            paddingBottom: 27, paddingRight: 0.0,
                            width: 130, height: 30, enableInsets: true)
    
    if #available(iOS 11.0, *) {
      termsLabel.layoutAnchor(top: nil, left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor, centerX: view.centerXAnchor,
                              centerY: nil, paddingTop: 0.0,
                              paddingLeft: 40, paddingBottom: 23, paddingRight: 40,
                              width: 0.0, height: 50, enableInsets: true)
    } else {
      termsLabel.layoutAnchor(top: nil, left: view.leftAnchor,
                              bottom: view.bottomAnchor, right: view.rightAnchor,
                              centerX: view.centerXAnchor, centerY: nil, paddingTop: 0.0,
                              paddingLeft: 40, paddingBottom: 23, paddingRight: 40,
                              width: 0.0, height: 30, enableInsets: true)
    }
  }
}


extension SocialMediaViewController{
  
  @objc func skipButtonTapped(){
    StrongBoxController.sharedInstance.storeUserDefault(data: true, storeType: "HomePagePopUp")
    StrongBoxController.sharedInstance.storeUserDefault(data: true, storeType: "HomePage")
    GIDSignIn.sharedInstance()?.signOut()
//    loginManager.logOut()
    popOrPushToViewController( "WelcomeScreen")
  }
  
  
  @objc func fbButtontapped() {
    loginManager.logIn(permissions: [.publicProfile], viewController: self) { (loginResult) in
        switch loginResult {
        case .failed(let error):
          print(error as? String as Any)
        case .cancelled:
          return
        case .success( _, _, _):

            if(AccessToken.current != nil){
                GraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email,picture.width(480).height(480)"]).start(completionHandler: { (connection, result, error) in
              guard let Info = result as? [String: Any] else { return }

              guard let name = Info["name"] as? String else{ return }

              if let imageURL = ((Info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                DispatchQueue.main.async { [weak self] in
                 //   guard let self = self else { return }Changes made by Apeksha
                  guard let `self` = self else { return }
                  Networking.sharedInstance.proccessImage(imageURL, profileName: name)
                  self.popOrPushToViewController( "WelcomeScreen")
                }
              }
              if(error == nil){
                print("result")
              }
            })
          }
        }
      }

  }
  
  //MARK: Twitter SignIn
  @objc func twitterButtonTapped() {
    if Reachability.isConnectedToNetwork() {
      TWTRTwitter.sharedInstance().logIn(with: self) { (session, error) in
        if (session != nil) {
          guard let name = session?.userName else { return }
          let twitterClient = TWTRAPIClient(userID: session?.userID)
          twitterClient.loadUser(withID: (session?.userID)!, completion: { (user, error) in
            guard let imageURL = user?.profileImageLargeURL else { return }
            DispatchQueue.main.async { [weak self] in
              //   guard let self = self else { return }Changes made by Apeksha
              guard let `self` = self else { return }
              Networking.sharedInstance.proccessImage(imageURL, profileName: name)
              self.popOrPushToViewController( "WelcomeScreen")
            }
          })
        } else {
        }
      }
    }else{
      showConfirmAlert(title: "", message: "Sorry, we can't connect right now. Please check your internet connection and try again.", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
    }
  }
  
  
  @objc func googleButtonTapped() {
    if Reachability.isConnectedToNetwork() {
      GIDSignIn.sharedInstance().delegate =   self
      GIDSignIn.sharedInstance().uiDelegate = self
      GIDSignIn.sharedInstance().signIn()
    }else{
      showConfirmAlert(title: "", message: "Sorry, we can't connect right now. Please check your internet connection and try again.", buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
    }
  }
  
}
