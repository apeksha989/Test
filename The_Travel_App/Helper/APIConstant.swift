//
//  APIConstant.swift
//  Haggle
//
//  Created by Anil Kumar on 11/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//
struct BudleIdentifire {
  
    static let Identifire = "com.perfutilconsultingltd.haggle"
}

struct APPURL {
  private struct Domains {
    static let baseURL = "https://api.currencystack.io/currency?base="
  }
  static let Domain = Domains.baseURL
}

struct Key {
  
  struct CurrencyStack{
    static let Key = "x9a98e6361a60cd4d0fa17851fd9aae7"
  }
  
  struct IDPal {
    static let LicenseKey : String = "6PT2-52D2-TFT8-F7YU"
    static let UUID       : String = "32ceebc9"
  }
  
  struct Stripe {
    static let StripPublishableKey      = "pk_test_HBk7kGBnLK1bi664Hr7sWw9D00ZyRjx4sd"
    static let appleMerchantIdentifier  = "merchant.com.perfutilconsultingltd.haggle"
    static let secratKey                = "sk_test_CNLGiLaQdK3Cw99kjNuoiJeA00vRnpPr6W"
  }
  
  struct googleClientID {
    static let ClientID = "1039197645783-4fverulb9vj5kfab2aq511jf1vg7krg8.apps.googleusercontent.com"
  }
  
  struct Twitter {
    static let ConsumerKey = "FANVwkR4V1qH7wl2OiDB53XPJ"
    static let consumerSecret  = "jpaCk5gHB4qEY15OFasM7EGzzTxj8w8xRziFoz4tdFmWDi6ZWh"
  }
  
}
