//
//  UserDetails.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 17/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation

class UserDetails {
  
  private static var Shared: UserDetails?
  
  static var shared: UserDetails {
    if Shared == nil {
      Shared = UserDetails()
    }
    return Shared!
  }
  class func destroy() {
    Shared = nil
  }
  
  
  // Dictionary Properties
  //var notificationArray : [Int:[String:[String]]] = [:]
  var notificationArray            : [[String]]  = []
  var dict1                       : [Int:[String:[String]]] = [:]
  var tripArray                   : [Int:[String:Any]]      = [:]
  var IDPalSubmissionId = 0
  static var creatCategoryArray    : [Int:[String:Any]]      = [:]
  static var colorArrayRandomPicker: [Int:[String:[Data]]]      = [:]
  static var totalExpenseAddition  : [Int:[Double]]          = [:]
  static var totalAmount           : [Int:[String:[String]]] = [:]
  static var tripDate              : [Int:Date]              = [:]
  static var tripEndDate           : [Int:Date]              = [:]
  static var startDates            : [Date]                  = []
  static var listExpenses1         : [String:String]         = [:]
  static var countryAndCodeAndIcon : [String:[String]]       = [:]
  static var HomeSreenUpdateValues : [String:[String]]       = [:]
  static var categoryWholeArray    : [Int:ExpandableNames]   = [:]
  static var imageArray            : [UIImage]               = []
  static var dateArray             : [String]                = []
  static var amountArray           : [String]                = []
  static var nameArr               : [String]                = []
  static var codeArr               : [String]                = []
  static var amountArr             : [String]                = []
  static var timeAgoArr            : [String]                = []
  static var categoryArr           : [String]                = []
  
  // String Properties
  
  static var haggleHomeFlagName            = String()
  static var AddToWalletScannedAmount      = String()
  static var categoryName                  = String()
  static var categoryNumber                = String()
  static var totelBudget                   = String()
  static var reminingBudgetAmountConstant  = String()
  var tripBudgetConvertionAmount  = String()  
  static var selectedDate             = String()
  static var haggleHomeCode = String()
  static var haggleTargetCode = String()
  static var haggleHomeIcon = String()
  static var haggleTargetIcon = String()
  static var haggleHomeSymbol = String()
  static var haggleTargetSymbol = String()
  
  // Integer Properties
  
  static var validKey   = Int()
  static var budgetID   = Int()
  static var countCheck = 0
  static var tripId     = 0
  static var tot : Double = 0
  
  // Date Properties
  
  static var tripStartDatePreviousSelected = Date()
  static var tripEndDatePreviousSelected   = Date()
  
  // UIImage Properties
  
  static var selectedImage = UIImage()
  static var colorIdForTrip: [Int:Int?] = [:]
  // Boolean Properties
  
  static var tripStartedFlag       = false
  static var editButtonTappingFlag = false
  static var homeYesTapped         = true
  static var previousDateSelected  = true
  static var searchCountryFlag     = false
  static var privacyFlag : Bool!
  static var delegateFlag = Bool()
  
  static var colorDataArray : [[Data]] = []
  
  // Default Categories
  
  static var names = ["Food/Drink", "Tours", "Transport", "Gifts","Flights", "Shopping", "Activities","Entertainment","Accomodation","Other"]
  static var icons = ["Food_Category", "Tours", "Transport_Category", "Gifts_Category","Flights_Category","Shopping_Category","Activities_category","Entertainment_category", "Accomodation_Category","Other_Category"]
  
  // Recent Country List
  static var recentCountry     = ["United States","Ireland","United Kingdom","India","Australia","Canada","Singapore"]
  static var recentCountryName = ["US Dollar","Euro","British Pound","Indian Rupee","Australian Dollar","Canadian Dollar","Singapore Dollar"]
  static var recentCountryCode = ["USD","EUR","GBP","INR","AUD","CAD","SGD"]
  static var recentCountryFlag = ["us","eu","gb","in","au","ca","sg"]
  
  static var colorArray        = [
    
    [UIColor(red: 0.33, green: 0.66, blue: 0.89, alpha: 1),UIColor(red: 0.46, green: 0.87, blue: 0.98, alpha: 1)],
    
    [UIColor(red: 0.14, green: 0.74, blue: 0.73, alpha: 1), UIColor(red: 0.27, green: 0.91, blue: 0.58, alpha: 1)],
    
    [UIColor(red: 0.98, green: 0.85, blue: 0.38, alpha: 1), UIColor(red: 0.97, green: 0.42, blue: 0.11, alpha: 1)],
    
    [UIColor(red: 0.97, green: 0.31, blue: 0.20, alpha: 1), UIColor(red: 0.91, green: 0.23, blue: 0.16, alpha: 1)],
    
    [UIColor(red: 1.00, green: 0.93, blue: 0.00, alpha: 1), UIColor(red: 1.00, green: 0.87, blue: 0.47, alpha: 1)]
    
  ]
  
  struct TargetCurrency{
    static var targetCurrencyCode = "AUD"
    static var targetCurrencySymbole = "$"
  }
  
  
  class locationProperties {
    static let shared = locationProperties()
    private init() {}
    var countryName : String?
    var countryCode : String?
  }
  
  class Identifires{
    static let shared = Identifires()
    private init() {}
    var getSetIdentifire = Int()
  }
  
  struct CountryDelegateModel {
    static var code = String()
    static var icon = String()
    static var Homeicon = String()
    static var TargetIcon = String()
    static var identifire = Int()
    static var flagName   = String()
  }
  
  struct geticon {
    static var icon = String()
  }
  
  struct ClickBool {
    static var AddTripControllerClicked = true
    static var clicked = true
    static var ManualClicked = true
  }
  
  struct ChangeHomeCurrency {
    static var homeCurrency = true
    static var homeCurrencyCode = String()
    static var homeCurrencyName = String()
    static var homeCurrencyIcon = String()
  }
  
  struct getAddtripeAttibutes{
    static var code = String()
    static var name = String()
    static var icon = String()
    static var value = String()
  }
  struct PercentageCalculation{
    static var scannedAmount = String()
    static var ConvertedAmount = String()
    static var code = String()
  }
  
  struct scannedCurrency{
    static var scannedCurrencyFlag = String()
    static var scannedCurrencyCode = String()
  }
  
  
  
  struct ExpandableNames:Codable {
    var isExpanded: Bool
    var names: [String]
    var icons: [String]
  }
  
  struct SelectExpenseCurrencyBool {
    static var AddExpenseClicked = true
  }
  
  struct addExpensiveValue {
    static var code = String()
  }
  
  struct selectNewTrip {
    static var clickedNewTrip = true
  }
  
  struct AddToWallet {
    static var WalletClicked = true
    static var WalletBackClicked = true
    static var ConfirmClicked = true
  }
  
  struct homeCurrencyChanged{
    static var homeCurrencyChangedBool = false
  }
  
  struct newTripCreated {
    static var tripCreatedBool = false
  }
  
  struct changedManualCurrency {
    static var changedManualCurrencyBool = false
    static var manualScanImage = String()
    static var manualConvertImage = String()
  }
}
