
//
//  DataModelIten.swift
//  Haggle
//
//  Created by Anil Kumar on 19/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation

struct DataModelItem: Codable{
  
  let alpha2 : String?
  let alpha3 : String?
  let currencyCode : String?
  let id : Int?
  let name : String?
  let currencyName : String?
  
  enum CodingKeys: String, CodingKey {
    case alpha2 = "alpha2"
    case alpha3 = "alpha3"
    case currencyCode = "currencyCode"
    case id = "id"
    case name = "name"
    case currencyName = "currencyName"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    alpha2 = try values.decodeIfPresent(String.self, forKey: .alpha2)
    alpha3 = try values.decodeIfPresent(String.self, forKey: .alpha3)
    currencyCode = try values.decodeIfPresent(String.self, forKey: .currencyCode)
    id = try values.decodeIfPresent(Int.self, forKey: .id)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    currencyName = try values.decodeIfPresent(String.self, forKey: .currencyName)
  }
  
}
