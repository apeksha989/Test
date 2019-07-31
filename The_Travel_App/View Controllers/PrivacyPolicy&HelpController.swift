//
//  PrivacyPolicy&HelpController.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 31/05/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import WebKit

enum URLType :String{
  case privacyUrl = "https://www.thetravel-app.com/privacy-policy"
  case helpUrl = "https://www.thetravel-app.com/help"
}

class PrivacyPolicy_HelpController: UIViewController {
    
  private let backButton            = UIButtonFactory(title: "")
    .setBackgroundImage(image: "BackBtn")
    .setTintColor(color: .white)
    .addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    .build()
  
  private let navigationBarview     = UIViewFactory()
    .backgroundColor(color: .white)
  .build()
  
  private let titleLabel = UILabelFactory(text: "")
    .textAlignment(with: .center)
    .textFonts(with: UIFont(name: "Montserrat-SemiBold", size: 19)!)
    .textColor(with: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1))
    .build()
  
  lazy var webView : WKWebView = {
     var webV = WKWebView()
    return webV
  }()
  
  /// View which contains the loading text and the spinner
  let loadingView = UIView()
  
  /// Spinner shown during load the TableView
  let spinner = UIActivityIndicatorView()
  
  /// Text shown during load the TableView
  let loadingLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugPrint("<---------PrivacyPolicy_HelpController------------>😀")
    view.addSubview(navigationBarview)
    navigationBarview.addSubview(backButton)
    navigationBarview.addSubview(titleLabel)
    view.addSubview(webView)
    view.bringSubviewToFront(webView)
    
    webView.navigationDelegate = self
    
    switch UIDevice().type {
    case .iPhoneX,.iPhoneXS,.iPhoneXSmax,.iPhoneXR:
      
      navigationBarview.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 102.0, enableInsets: true)
      
      titleLabel.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: navigationBarview.centerXAnchor, centerY: navigationBarview.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 20.0, enableInsets: true)
      
      backButton.layoutAnchor(top: nil, left: navigationBarview.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: titleLabel.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
      
      webView.layoutAnchor(top: navigationBarview.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
      
      default:
    navigationBarview.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: webView.topAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 70, enableInsets: true)
    
    backButton.layoutAnchor(top: nil, left: navigationBarview.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: navigationBarview.centerYAnchor, paddingTop: 0.0, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
    
    titleLabel.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: navigationBarview.centerXAnchor, centerY: navigationBarview.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 30, enableInsets: true)
    
    webView.layoutAnchor(top: navigationBarview.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
    }
    
    setLoadingScreen()
    
    if UserDetails.privacyFlag {
      titleLabel.text = "Privacy Policy/T&C"
      webView.load(URLRequest(url: URL(string: URLType.privacyUrl.rawValue)!))
    }else{
      titleLabel.text = "Help"
      webView.load(URLRequest(url: URL(string: URLType.helpUrl.rawValue)!))
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    gradiantView(navigationBarview, self)
  }
  
  deinit {
    webView.removeFromSuperview()
    print("deint Webview")
  }
  
  @objc func backButtonTapped(){
    navigationController?.popViewController(animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    removeLoadingScreen()
    webView.stopLoading()
    webView.removeFromSuperview()
  }
}

extension PrivacyPolicy_HelpController: WKNavigationDelegate{
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    removeLoadingScreen()
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    showConfirmAlert(title: "", message: error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
  }
  
}


extension PrivacyPolicy_HelpController {
  
  private func setLoadingScreen() {
    
    loadingView.layer.masksToBounds = true
    loadingView.layer.cornerRadius = 5
    loadingView.backgroundColor = hexStringToUIColor(hex: "#bbdefb")
    
    spinner.style = .whiteLarge
    spinner.startAnimating()
    
    loadingView.addSubview(spinner)
    webView.addSubview(loadingView)
    
    loadingView.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 100, height: 100, enableInsets: true)
    
    spinner.layoutAnchor(top: nil, left: nil, bottom: nil, right: nil, centerX: loadingView.centerXAnchor, centerY: loadingView.centerYAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 30, height: 30, enableInsets: true)
    
  }
  
  private func removeLoadingScreen() {
    
    spinner.hidesWhenStopped = true
    spinner.stopAnimating()
    spinner.isHidden = true
    loadingView.removeFromSuperview()
    
  }
}

