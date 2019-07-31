//
//  UISearch.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 17/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation


final class UISearchControllerFactory{
  private var search : UISearchBar
  
  init() {
    search = UISearchBar()
    search.translatesAutoresizingMaskIntoConstraints = false
    search.searchBarStyle  = UISearchBar.Style.prominent
    search.barTintColor    = UIColor.white
    search.isTranslucent   = false
    search.backgroundImage = UIImage()
    search.placeholder     = "Search"
  }
  
  func build() -> UISearchBar {
    return search
  }
  
}
