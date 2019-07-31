//
//  DocumentViewController.swift
//  The_Travel_App
//
//  Created by Anil Kumar on 20/05/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
  
  let backButton = UIButtonFactory(title: "")
  .setBackgroundImage(image: "Black_Back_Btn")
  .addTarget(self, action: #selector(backClicked), for: .touchUpInside)
  .build()
  
  
//  let zoomScrollView = UIScrollViewFactory()
//  .build()
  
  let imageView = UIImageFactory()
  .build()
  
  var isZooming = false
  var originalImageCenter:CGPoint?
  
  let dateLabel = UILabelFactory(text: "TEst")
  .textColor(with: UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1))
  .numberOf(lines: 0)
  .textFonts(with: UIFont(name: "Montserrat-Medium", size: 15)!)
  .build()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
//      let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
//      imageView.addGestureRecognizer(pinch)
      
      let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
      imageView.isUserInteractionEnabled = true
      self.imageView.addGestureRecognizer(pinch)
      
      imageView.contentMode = .scaleAspectFit
//      zoomScrollView.showsVerticalScrollIndicator = false
//      zoomScrollView.showsHorizontalScrollIndicator = false
//      zoomScrollView.delegate = self
////
//      zoomScrollView.minimumZoomScale = 1.0
//      zoomScrollView.maximumZoomScale = 10.0
//      zoomScrollView.zoomScale = 1.0
      
      debugPrint("<---------DocumentViewController------------>😀")
      view.addSubview(backButton)
      
//      zoomScrollView.addSubview(imageView)
//      view.addSubview(zoomScrollView)
      view.addSubview(imageView)
      view.addSubview(dateLabel)
      
      dateLabel.text = UserDetails.selectedDate
      imageView.image = UserDetails.selectedImage
      
       backButton.layoutAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0.0, paddingRight: 0.0, width: 60, height: 60, enableInsets: true)
      
      
//      zoomScrollView.layoutAnchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: view.centerYAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 100, paddingRight: 10, width: 0.0, height: 0.0, enableInsets: true)
      
      imageView.layoutAnchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, centerX: nil, centerY: view.centerYAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 100, paddingRight: 10, width: 0.0, height: 0.0, enableInsets: true)
      
      dateLabel.layoutAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 15, paddingRight: 0.0, width: view.frame.size.width, height: 20, enableInsets: true)
    }
    
  @objc func backClicked(){
    navigationController?.popViewController(animated: true)
  
  }
}

extension DocumentViewController : UIScrollViewDelegate{
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
     return imageView
  }
  

  @objc func pinch(sender:UIPinchGestureRecognizer) {
      if sender.state == .began {
        let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
        let newScale = currentScale*sender.scale
        if newScale > 1 {
          self.isZooming = true
        }
      } else if sender.state == .changed {
        guard let view = sender.view else {return}
        let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                  y: sender.location(in: view).y - view.bounds.midY)
        let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
          .scaledBy(x: sender.scale, y: sender.scale)
          .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
        let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
        var newScale = currentScale*sender.scale
        if newScale < 1 {
          newScale = 1
          let transform = CGAffineTransform(scaleX: newScale, y: newScale)
          self.imageView.transform = transform
          sender.scale = 1
        }else {
          view.transform = transform
          sender.scale = 1
        }
      } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
        guard let center = self.originalImageCenter else {return}
        UIView.animate(withDuration: 0.3, animations: {
          self.imageView.transform = CGAffineTransform.identity
          self.imageView.center = center
        }, completion: { _ in
          self.isZooming = false
        })
      }
    }

}

