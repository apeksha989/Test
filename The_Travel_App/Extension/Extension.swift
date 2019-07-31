//
//  Extension.swift
//  Haggle
//
//  Created by Anil Kumar on 11/02/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation
import UIKit
import AVKit

extension UIViewController {
  
  func showConfirmAlert(title: String?, message: String?, buttonTitle: String, buttonStyle: UIAlertAction.Style, confirmAction: ((UIAlertAction) -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle, handler:confirmAction))
    present(alert, animated: true, completion: nil)
  }  
  
  func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
  }
  
  func fixOrientation(img: UIImage) -> UIImage {
    if (img.imageOrientation == .up) {
      return img
    }
    UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
    let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
    img.draw(in: rect)
    
    let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return normalizedImage
  }
  
  func matches(for regex: String, in text: String) -> [String] {
    do {
      let regex = try NSRegularExpression(pattern: regex)
      let results = regex.matches(in: text,
                                  range: NSRange(text.startIndex..., in: text))
      return results.map {
        String(text[Range($0.range, in: text)!])
      } 
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
      return []
    }
  }
  
  func removeDotCommas(Values: String)-> String{
    var value = Values.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
    value =  value.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
    return value
  }
  
  func getSymbolForCurrencyCode(code: String) -> String {
    var candidates: [String] = []
    let locales: [String] = NSLocale.availableLocaleIdentifiers
    for localeID in locales {
      guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: code) else {
        continue
      }
      if symbol.count == 1 {
        return symbol
      }
      candidates.append(symbol)
    }
    let sorted = sortAscByLength(list: candidates)
    if sorted.count < 1 {
      return ""
    }
    return sorted[0]
  }
  
  func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
    let locale = Locale(identifier: localeID as String)
    guard let code = locale.currencyCode else {
      return nil
    }
    if code != currencyCode {
      return nil
    }
    guard let symbol = locale.currencySymbol else {
      return nil
    }
    return symbol
  }
  
  func sortAscByLength(list: [String]) -> [String] {
    return list.sorted(by: { $0.count < $1.count })
  }
  
  func setView(view: UIView, hidden: Bool) {
    if hidden == true{
      UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
        view.isHidden = hidden
      })
    }else{
      UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
        view.isHidden = hidden
      })
    }
  }
  
  func dateDetector(){
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
  }
  
  @objc func appMovedToBackground() {
    print("Print Current Date-->",Date())
    HomeScreenUpdate.shared.updateHomeScreen(self, Date())
    if let controller = self as? HomeViewController{
      let indexPath = IndexPath(item: 0, section: 0)
      controller.collectionView.reloadItems(at: [indexPath])
    }
    
  }
  
}

extension UIImage {
    
  func croppedInRect(rect: CGRect) -> UIImage {
    func rad(_ degree: Double) -> CGFloat {
      return CGFloat(degree / 180.0 * .pi)
    }
    
    var rectTransform: CGAffineTransform
    switch imageOrientation {
    case .left:
      rectTransform = CGAffineTransform(rotationAngle: rad(90)).translatedBy(x: 0, y: -self.size.height)
    case .right:
      rectTransform = CGAffineTransform(rotationAngle: rad(-90)).translatedBy(x: -self.size.width, y: 0)
    case .down:
      rectTransform = CGAffineTransform(rotationAngle: rad(-180)).translatedBy(x: -self.size.width, y: -self.size.height)
    default:
      rectTransform = .identity
    }
    rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)
    
    let imageRef = self.cgImage!.cropping(to: rect.applying(rectTransform))
    let result = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
    return result
  }
}
extension UIImage.Orientation {
  
  init(_ cgOrientation: CGImagePropertyOrientation) {
    // we need to map with enum values becuase raw values do not match
    switch cgOrientation {
    case .up: self = .up
    case .upMirrored: self = .upMirrored
    case .down: self = .down
    case .downMirrored: self = .downMirrored
    case .left: self = .left
    case .leftMirrored: self = .leftMirrored
    case .right: self = .right
    case .rightMirrored: self = .rightMirrored
    }
  }
  
  
  /// Returns a UIImage.Orientation based on the matching cgOrientation raw value
  static func orientation(fromCGOrientationRaw cgOrientationRaw: UInt32) -> UIImage.Orientation? {
    var orientation: UIImage.Orientation?
    if let cgOrientation = CGImagePropertyOrientation(rawValue: cgOrientationRaw) {
      orientation = UIImage.Orientation(cgOrientation)
    } else {
      orientation = nil // only hit if improper cgOrientation is passed
    }
    return orientation
  }
}

extension AVCaptureDevice {
  
  func configureDesiredFrameRate(_ desiredFrameRate: Double) {
    var isFPSSupported = false
    do {
      if let videoSupportedFrameRateRanges = activeFormat.videoSupportedFrameRateRanges as? [AVFrameRateRange] {
        for range in videoSupportedFrameRateRanges {
          if (range.maxFrameRate >= Double(desiredFrameRate) && range.minFrameRate <= desiredFrameRate) {
            isFPSSupported = true
            break
          }
        }
      }
      if isFPSSupported {
        try lockForConfiguration()
        activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(desiredFrameRate))
        activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(desiredFrameRate))
        unlockForConfiguration()
      }
    } catch {
      //      print("lockForConfiguration error: \(error.localizedDescription)")
    }
  }
}

extension String {
  func index(from: Int) -> Index {
    return self.index(startIndex, offsetBy: from)
  }

  func substring(from: Int) -> String {
    let fromIndex = index(from: from)
    return substring(from: fromIndex)
  }
  
  func substring(to: Int) -> String {
    let toIndex = index(from: to)
    return  substring(to: toIndex)
  }
  
  func substring(with r: Range<Int>) -> String {
    let startIndex = index(from: r.lowerBound)
    let endIndex = index(from: r.upperBound)
    return substring(with: startIndex..<endIndex)
  }
  var isNumeric: Bool {
    guard self.count > 0 else { return false }
    let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    return Set(self).isSubset(of: nums)
  }
}


extension NSMutableAttributedString{
  func setColorForText(_ textToFind: String?, with color: UIColor) {
    
    let range:NSRange?
    if let text = textToFind{
      range = self.mutableString.range(of: text, options: .caseInsensitive)
    }else{
      range = NSMakeRange(0, self.length)
    }
    if range!.location != NSNotFound {
      addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
    }
  }
}
extension UIButton {
  func loadingIndicator(show: Bool) {
    let tag = 808404
    if show {
      isEnabled = false
      let indicator = UIActivityIndicatorView()
      let buttonHeight = self.bounds.size.height
      let buttonWidth = self.bounds.size.width
      indicator.color = UIColor.white
      indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
      indicator.tag = tag
      self.addSubview(indicator)      
      self.bringSubviewToFront(indicator)
      indicator.startAnimating()
    } else {
      isEnabled = true
      if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
      }
    }
  }
}

extension Notification.Name {
  static let BackButtonTapped = Notification.Name("ManualInputController")
  static let AddtripPageTapped = Notification.Name("AddTripController")
  static let UpdatedHomeScreenValues = Notification.Name("HomeViewController")
}

extension UIView {
  
  func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
    var topInset = CGFloat(0)
    var bottomInset = CGFloat(0)
    
    if #available(iOS 11, *), enableInsets {
      let insets = self.safeAreaInsets
      topInset = insets.top
      bottomInset = insets.bottom

    }
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
    }
    if let left = left {
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
    }
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
  }
  func anchor1 (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, centerY : NSLayoutYAxisAnchor? ,paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
    var topInset = CGFloat(0)
    var bottomInset = CGFloat(0)
    
    if #available(iOS 11, *), enableInsets {
      let insets = self.safeAreaInsets
      topInset = insets.top
      bottomInset = insets.bottom
    }
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
    }
    if let left = left {
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
    }
    if let centerY = centerY{
      centerYAnchor.constraint(equalTo: centerY, constant: 0.0).isActive = true
    }
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
      centerYAnchor.constraint(equalTo: centerYAnchor)
    }
    
  }
  
  func layoutAnchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, centerX : NSLayoutXAxisAnchor?, centerY : NSLayoutYAxisAnchor? ,paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
    var topInset = CGFloat(0.0)
    var bottomInset = CGFloat(0.0)
    
    if #available(iOS 11, *), enableInsets {
      let insets = self.safeAreaInsets
      topInset = insets.top
      bottomInset = insets.bottom
      
    }
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
    }
    if let left = left {
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
    }
    if let centerX = centerX{
      centerXAnchor.constraint(equalTo: centerX, constant: 0.0).isActive = true
    }
    if let centerY = centerY{
      centerYAnchor.constraint(equalTo: centerY, constant: 0.0).isActive = true
    }
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
  }
  
}

extension UITextField{
  func setLeftPaddingPoints(_ space: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }
}

extension UIApplication {
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
}

public enum Model : String {
  case simulator   = "simulator/sandbox",
  iPod1            = "iPod 1",
  iPod2            = "iPod 2",
  iPod3            = "iPod 3",
  iPod4            = "iPod 4",
  iPod5            = "iPod 5",
  iPad2            = "iPad 2",
  iPad3            = "iPad 3",
  iPad4            = "iPad 4",
  iPhone4          = "iPhone 4",
  iPhone4S         = "iPhone 4S",
  iPhone5          = "iPhone 5",
  iPhone5S         = "iPhone 5S",
  iPhone5C         = "iPhone 5C",
  iPadMini1        = "iPad Mini 1",
  iPadMini2        = "iPad Mini 2",
  iPadMini3        = "iPad Mini 3",
  iPadAir1         = "iPad Air 1",
  iPadAir2         = "iPad Air 2",
  iPadPro9_7       = "iPad Pro 9.7\"",
  iPadPro9_7_cell  = "iPad Pro 9.7\" cellular",
  iPadPro10_5      = "iPad Pro 10.5\"",
  iPadPro10_5_cell = "iPad Pro 10.5\" cellular",
  iPadPro12_9      = "iPad Pro 12.9\"",
  iPadPro12_9_cell = "iPad Pro 12.9\" cellular",
  iPhone6          = "iPhone 6",
  iPhone6plus      = "iPhone 6 Plus",
  iPhone6S         = "iPhone 6S",
  iPhone6Splus     = "iPhone 6S Plus",
  iPhoneSE         = "iPhone SE",
  iPhone7          = "iPhone 7",
  iPhone7plus      = "iPhone 7 Plus",
  iPhone8          = "iPhone 8",
  iPhone8plus      = "iPhone 8 Plus",
  iPhoneX          = "iPhone X",
  iPhoneXS         = "iPhone XS",
  iPhoneXSmax      = "iPhone XS Max",
  iPhoneXR         = "iPhone XR",
  unrecognized     = "?unrecognized?"
}

public extension UIDevice {
   var type: Model {
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafePointer(to: &systemInfo.machine) {
      $0.withMemoryRebound(to: CChar.self, capacity: 1) {
        ptr in String.init(validatingUTF8: ptr)
        
      }
    }
    var modelMap : [ String : Model ] = [
      "i386"       : .simulator,
      "x86_64"     : .simulator,
      "iPod1,1"    : .iPod1,
      "iPod2,1"    : .iPod2,
      "iPod3,1"    : .iPod3,
      "iPod4,1"    : .iPod4,
      "iPod5,1"    : .iPod5,
      "iPad2,1"    : .iPad2,
      "iPad2,2"    : .iPad2,
      "iPad2,3"    : .iPad2,
      "iPad2,4"    : .iPad2,
      "iPad2,5"    : .iPadMini1,
      "iPad2,6"    : .iPadMini1,
      "iPad2,7"    : .iPadMini1,
      "iPhone3,1"  : .iPhone4,
      "iPhone3,2"  : .iPhone4,
      "iPhone3,3"  : .iPhone4,
      "iPhone4,1"  : .iPhone4S,
      "iPhone5,1"  : .iPhone5,
      "iPhone5,2"  : .iPhone5,
      "iPhone5,3"  : .iPhone5C,
      "iPhone5,4"  : .iPhone5C,
      "iPad3,1"    : .iPad3,
      "iPad3,2"    : .iPad3,
      "iPad3,3"    : .iPad3,
      "iPad3,4"    : .iPad4,
      "iPad3,5"    : .iPad4,
      "iPad3,6"    : .iPad4,
      "iPhone6,1"  : .iPhone5S,
      "iPhone6,2"  : .iPhone5S,
      "iPad4,1"    : .iPadAir1,
      "iPad4,2"    : .iPadAir2,
      "iPad4,4"    : .iPadMini2,
      "iPad4,5"    : .iPadMini2,
      "iPad4,6"    : .iPadMini2,
      "iPad4,7"    : .iPadMini3,
      "iPad4,8"    : .iPadMini3,
      "iPad4,9"    : .iPadMini3,
      "iPad6,3"    : .iPadPro9_7,
      "iPad6,11"   : .iPadPro9_7,
      "iPad6,4"    : .iPadPro9_7_cell,
      "iPad6,12"   : .iPadPro9_7_cell,
      "iPad6,7"    : .iPadPro12_9,
      "iPad6,8"    : .iPadPro12_9_cell,
      "iPad7,3"    : .iPadPro10_5,
      "iPad7,4"    : .iPadPro10_5_cell,
      "iPhone7,1"  : .iPhone6plus,
      "iPhone7,2"  : .iPhone6,
      "iPhone8,1"  : .iPhone6S,
      "iPhone8,2"  : .iPhone6Splus,
      "iPhone8,4"  : .iPhoneSE,
      "iPhone9,1"  : .iPhone7,
      "iPhone9,2"  : .iPhone7plus,
      "iPhone9,3"  : .iPhone7,
      "iPhone9,4"  : .iPhone7plus,
      "iPhone10,1" : .iPhone8,
      "iPhone10,2" : .iPhone8plus,
      "iPhone10,3" : .iPhoneX,
      "iPhone10,6" : .iPhoneX,
      "iPhone11,2" : .iPhoneXS,
      "iPhone11,4" : .iPhoneXSmax,
      "iPhone11,6" : .iPhoneXSmax,
      "iPhone11,8" : .iPhoneXR
    ]
    
    if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
      return model
    }
    return Model.unrecognized
  }
}

extension UITextField {
  
  func addHideinputAccessoryView() {
    
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                               target: self, action: #selector(self.resignFirstResponder))
    toolbar.setItems([item], animated: true)
    
    self.inputAccessoryView = toolbar
  }
  
}


extension Array {
  subscript(safe index: Index) -> Element? {
    let isValidIndex = index >= 0 && index < count
    return isValidIndex ? self[index] : nil
  }
}

extension Double {
  func roundToDecimal(_ fractionDigits: Int) -> Double {
    let multiplier = pow(10, Double(fractionDigits))
    return Darwin.round(self * multiplier) / multiplier
  }
}
extension Array where Element: Comparable {
  func containsSameElements(as other: [Element]) -> Bool {
    return self.count == other.count && self.sorted() == other.sorted()
  }
}


extension UITableView {
  
  enum scrollsTo {
    case top,bottom
  }
  
  func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1)
    messageLabel.numberOfLines = 0;
    messageLabel.alpha = 0.52
    messageLabel.textAlignment = .center;
    messageLabel.font = UIFont(name: "Montserrat-Medium", size: 29)
    messageLabel.sizeToFit()
    
    self.backgroundView = messageLabel;
    self.separatorStyle = .none;
  }
  
  func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
  }
  
  public func reloadData(_ completion: @escaping ()->()) {
    UIView.animate(withDuration: 0, animations: {
      self.reloadData()
    }, completion:{ _ in
      completion()
    })
  }
  
  func scroll(to: scrollsTo, animated: Bool) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
      let numberOfSections = self.numberOfSections
      let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
      switch to{
      case .top:
        if numberOfRows > 0 {
          let indexPath = IndexPath(row: 0, section: 0)
          self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
        break
      case .bottom:
        if numberOfRows > 0 {
          let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
          self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        break
      }
    }
  }
}

extension UICollectionView {
  func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1)
    messageLabel.numberOfLines = 0;
    messageLabel.alpha = 0.52
    messageLabel.textAlignment = .center;
    messageLabel.font = UIFont(name: "Montserrat-Medium", size: 29)
    messageLabel.sizeToFit()
    
    self.backgroundView = messageLabel;
  }
  
  func restore() {
    self.backgroundView = nil
  }
}

extension UITapGestureRecognizer {
  
  func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize.zero)
    let textStorage = NSTextStorage(attributedString: label.attributedText!)
    
    // Configure layoutManager and textStorage
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0
    textContainer.lineBreakMode = label.lineBreakMode
    textContainer.maximumNumberOfLines = label.numberOfLines
    let labelSize = label.bounds.size
    textContainer.size = labelSize
    
    // Find the tapped character location and compare it to the specified range
    let locationOfTouchInLabel = self.location(in: label)
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
    let locationOfTouchInTextContainer = CGPoint(x: (locationOfTouchInLabel.x - textContainerOffset.x), y:  (locationOfTouchInLabel.y - textContainerOffset.y))
    let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    
    return NSLocationInRange(indexOfCharacter, targetRange)
  }
  
}

extension UIActivityIndicatorView {
  func assignColor(_ color: UIColor) {
    self.color = color
  }
}

extension Date {
  
  // Convert local time to UTC (or GMT)
  func toGlobalTime() -> Date {
    let timezone = TimeZone.current
    let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
    return Date(timeInterval: seconds, since: self)
  }
  
  // Convert UTC (or GMT) to local time
  func toLocalTime() -> Date {
    let timezone = TimeZone.current
    let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
    return Date(timeInterval: seconds, since: self)
  }
  
  func isBetween(_ date1: Date, and date2: Date) -> Bool {
    return (min(date1, date2) ... max(date1, date2)) ~= self
  }
  
}
