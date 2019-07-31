//
//  UIPageController.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 17/06/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation


final class UIPageControlFactory{
  private let pageControle: UIPageControl
  init() {
    pageControle = UIPageControl()
    pageControle.translatesAutoresizingMaskIntoConstraints = false
  }
  func setBackgroundColor(color:UIColor)->Self{
    pageControle.backgroundColor = color
    return self
  }
  func setTintColor(color:UIColor)->Self{
    pageControle.tintColor = color
    return self
  }
  func setCurrentPageIndicatorTintColor(color:UIColor)->Self{
    pageControle.currentPageIndicatorTintColor = color
    return self
  }
  func pageIndicatorTintColor(color:UIColor)->Self{
    pageControle.pageIndicatorTintColor = color
    return self
  }
  func setNumberOfPages(value:Int)->Self{
    pageControle.numberOfPages = value
    return self
  }
  func build() -> UIPageControl {
    return pageControle
  }
}

