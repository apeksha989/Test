//
//  ConstantRegex.swift
//  Haggle
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation


class RegExpression {
  
  private static var privateSharedInstance: RegExpression?
  
  static var shared: RegExpression {
    if privateSharedInstance == nil {
      privateSharedInstance = RegExpression()
    }
    return privateSharedInstance!
  }
  class func destroy() {
    privateSharedInstance = nil
  }
  
  let wholeRegex = "([/0-9,/0-9./0-9,/.]+|)(\\p{Sc}|AUD|AED|AFN|ALL|AMD|ANG|AOA|AWG|AZN|BAM|BBD|BDT|BGN|BHD|BIF|BMD|BND|BOB|BRL|BSD|BTN|BWP|BYN|BZD|CAD|CDF|CHF|CLP|CNY|COP|CRC|CUP|CVE|CZK|DJF|DKK|DOP|DZD|EGP|ERN|ETB|EUR|FJD|FKP|GBP|GEL|GHS|GIP|GMD|GNF|GTQ|GYD|HKD|HNL|HRK|HTG|HUF|IDR|ILS|INR|IQD|IRR|ISK|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LRD|LTL|LYD|MAD|MDL|MGA|MKD|MMK|MNT|MOP|MRO|MUR|MVR|MWK|MXN|MYR|MZN|NAD|NGN|NIO|NOK|NPR|NZD|OMR|PEN|PGK|PHP|PKR|PLN|PYG|QAR|RON|RSD|RUB|RWF|SAR|SBD|SCR|SDG|SEK|SGD|SHP|SLL|SOS|SRD|STD|SVC|SYP|SZL|THB|TJS|TMT|TOP|TRY|TTD|TWD|TZS|UAH|UGX|USD|UYU|UZS|VEF|VND|VUV|WST|XAF|XCD|XDR|XOF|XPF|YER|ZMW|ZAR|)([0-9,/0-9./0-9,/.]+|)"
  
  let symbolRegex = "\\p{Sc}"
  
  let decimalLastDigits = "\\.\\d{1,2}|\\d{1,2}"
  
  let NumberRegex = "(\\d+[,]*[\\.]*)"
  
  let CodesRegex = "AED|AFN|AUD|ALL|AMD|ANG|AOA|AWG|AZN|BAM|BBD|BDT|BGN|BHD|BIF|BMD|BND|BOB|BRL|BSD|BTN|BWP|BYN|BZD|CAD|CDF|CHF|CLP|CNY|COP|CRC|CUP|CVE|CZK|DJF|DKK|DOP|DZD|EGP|ERN|ETB|EUR|FJD|FKP|GBP|GEL|GHS|GIP|GMD|GNF|GTQ|GYD|HKD|HNL|HRK|HTG|HUF|IDR|ILS|INR|IQD|IRR|ISK|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LRD|LTL|LYD|MAD|MDL|MGA|MKD|MMK|MNT|MOP|MRO|MUR|MVR|MWK|MXN|MYR|MZN|NAD|NGN|NIO|NOK|NPR|NZD|OMR|PEN|PGK|PHP|PKR|PLN|PYG|QAR|RON|RSD|RUB|RWF|SAR|SBD|SCR|SDG|SEK|SGD|SHP|SLL|SOS|SRD|STD|SVC|SYP|SZL|THB|TJS|TMT|TOP|TRY|TTD|TWD|TZS|UAH|UGX|USD|UYU|UZS|VEF|VND|VUV|WST|XAF|XCD|XDR|XOF|XPF|YER|ZMW|ZAR"
  
  let currencysymbols = [
    "$" : "USD", // US Dollar
    "€" : "EUR", // Euro
    "₡" : "CRC", // Costa Rican Colón
    "£" : "GBP", // British Pound Sterling
    "₪" : "ILS", // Israeli New Sheqel
    "₹" : "INR", // Indian Rupee
    "¥" : "JPY", // Japanese Yen
    "₩" : "KRW", // South Korean Won
    "₦" : "NGN", // Nigerian Naira
    "₱" : "PHP", // Philippine Peso
    "zł": "PLN", // Polish Zloty
    "₲" : "PYG", // Paraguayan Guarani
    "฿" : "THB", // Thai Baht
    "₴" : "UAH", // Ukrainian Hryvnia
    "₫" : "VND", // Vietnamese Dong
  ]
  
  let codeToSymbole = [
    "USD" : "$",
    "THB" : "฿",
    "AFN" : "؋",
    "ALL" : "Lek",
    "DZD" : "دج",
    "EUR" : "€",
    "AOA" : "Kz",
    "XCD" : "$",
    "ARS" : "$",
    "AMD" : "դր",
    "AUD" : "$",
    "AZN" : "₼",
    "BSD" : "B$",
    "BHD" : "دب",
    "BDT" : "৳",
    "BBD" : "Bds$",
    "BZD" : "$",
    "XOF" : "CFA",
    "BTN" : "Nu",
    "BOB" : "Bs",
    "BAM" : "KM",
    "BWP" : "P",
    "BRL" : "R$",
    "BND" : "$",
    "BGN" : "Лв",
    "BIF" : "FBu",
    "CVE" : "CV$",
    "XAF" : "FCFA",
    "CAD" : "$",
    "CLP" : "$",
    "CNY" : "¥",
    "COP" : "$",
    "KMF" : "CF",
    "CRC" : "₡",
    "HRK" : "kn",
    "CUP" : "₱",
    "CZK" : "Kč",
    "DKK" : "Kr",
    "DJF" : "Fdj",
    "DOP" : "RD$",
    "EGP" : "جم",
    "SVC" : "$",
    "ERN" : "نافكا",
    "SZL" : "L",
    "ETB" : "Br",
    "FJD" : "FJ$",
    "GMD" : "D",
    "GEL" : "ლ",
    "GHS" : "GH₵",
    "GNF" : "FG",
    "GYD" : "G$",
    "HTG" : "G",
    "HNL" : "L",
    "HUF" : "Ft",
    "ISK" : "kr",
    "INR" : "₹",
    "IDR" : "Rp",
    "IRR" : "﷼",
    "IQD" : "عد",
    "JMD" : "$",
    "ILS" : "₪",
    "JPY" : "￥",
    "JOD" : "دا",
    "KZT" : "₸",
    "KES" : "Лв",
    "KPW" : "₩",
    "KRW" : "₩",
    "KWD" : "دك",
    "KGS" : "Лв",
    "LAK" : "₭",
    "LBP" : "لل",
    "LSL" : "L",
    "LRD" : "$",
    "LYD" : "لد",
    "CHF" : "CHF",
    "LTL" : "Lt",
    "MKD" : "Ден",
    "MWK" : "MK",
    "MYR" : "RM",
    "MVR" : "Rf",
    "MRO" : "UM",
    "MUR" : "₨",
    "MXN" : "$",
    "MDL" : "L",
    "MNT" : "₮",
    "MAD" : "دم",
    "MZN" : "MT",
    "MMK" : "K",
    "NAD" : "N$",
    "NPR" : "Re",
    "NZD" : "$",
    "NIO" : "C$",
    "NGN" : "₦",
    "NOK" : "kr",
    "OMR" : "رع",
    "PKR" : "₨",
    "PGK" : "K",
    "PYG" : "₲",
    "PEN" : "S/",
    "PHP" : "₱",
    "PLN" : "zł",
    "QAR" : "رق",
    "RON" : "lei",
    "RUB" : "₽",
    "RWF" : "R₣",
    "WST" : "WS$",
    "STD" : "Db",
    "SAR" : "رس",
    "RSD" : "din",
    "SCR" : "SR",
    "SLL" : "Le",
    "SGD" : "$",
    "SBD" : "$",
    "SOS" : "Sh",
    "ZAR" : "R",
    "SDG" : "جس",
    "LKR" : "Rs",
    "SRD" : "$",
    "SEK" : "kr",
    "SYP" : "LS",
    "TJS" : "ЅM",
    "TZS" : "TSh",
    "TTD" : "$",
    "TND" : "دت",
    "TRY" : "TL",
    "TMT" : "T",
    "UGX" : "USh",
    "UAH" : "₴",
    "AED" : "دإ",
    "GBP" : "£",
    "UYU" : "$",
    "UZS" : "so'm",
    "VUV" : "Vt",
    "VEF" : "Bs",
    "VND" : "₫",
    "YER" : "﷼",
    "ZMW" : "ZK"
  ]
  
}
