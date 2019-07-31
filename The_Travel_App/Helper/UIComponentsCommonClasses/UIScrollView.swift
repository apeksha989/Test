//
//  UIScrollView.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 17/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation


final class UIScrollViewFactory {
  private let scrollView: UIScrollView
  
  init(){
    scrollView = UIScrollView()
    scrollView.backgroundColor = UIColor.clear
    scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.frame.size.height)
    scrollView.isPagingEnabled = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func build() -> UIScrollView {
    return scrollView
  }
  
}

