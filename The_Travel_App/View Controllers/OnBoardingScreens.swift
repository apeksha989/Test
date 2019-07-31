//
//  OnBoardingScreens.swift
//  Haggle
//
//  Created by Anil Kumar on 28/03/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit


class OnBoardingScreens: UIViewController {
    
    var slides:[viewSlide] =  []
    var buttonTag : Int = 1
    lazy var dimView = UIView(frame: UIScreen.main.bounds)
    
    private let PageControl = UIPageControlFactory()
        .setBackgroundColor(color: .clear)
        .setTintColor(color: .black)
        .setCurrentPageIndicatorTintColor(color: .white)
        .pageIndicatorTintColor(color: UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.6))
        .build()
    
    private let scrollView = UIScrollViewFactory()
        .build()
    
    private var nextButton         = UIButtonFactory(title: "Next", style: .normal)
        .backgroundColour(with: UIColor.clear)
        .textAlignmentButton(with: NSTextAlignment.center)
        .setTitileColour(with: UIColor.white)
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 20.0)!)
        .registerSDK(Register: "Montserrat-Medium", type: "otf")
        .addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        .build()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      debugPrint("<---------OnBoardingScreens------------>😀")
        scrollView.delegate = self
        //    com.perfutilconsultingltd.HaggleSDK
        let bundle = Bundle(identifier: BudleIdentifire.Identifire)
        if let urlPath = bundle?.path(forResource: "test", ofType: "mp4"){
            VideoBackground.shared.play(view: view, url: URL(fileURLWithPath: urlPath))
        }else{
            try? VideoBackground.shared.play(view: view, videoName: "test", videoType: "mp4")
        }
        
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(dimView)
        view.addSubview(scrollView)
        view.addSubview(PageControl)
        view.addSubview(nextButton)
        
        view.bringSubviewToFront(scrollView)
        view.bringSubviewToFront(PageControl)
        view.bringSubviewToFront(nextButton)
        PageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 5, y: 5)
        }
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        setUpScrollView()
        setUpPageController()
        setUpNextButton()
    }
    
    @objc func nextButtonTapped() {
        rightButtonTapped(tag: buttonTag)
        buttonTag = buttonTag + 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        PageControl.currentPage = 0
        PageControl.numberOfPages = slides.count
        
        PageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }
    }
    
    func setUpScrollView() {
        
        let topConstraint      = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0.0)
        let leadingConstraint  = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0.0)
        let bottomConstraint   = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0.0)
        NSLayoutConstraint.activate([topConstraint,leadingConstraint,trailingConstraint,bottomConstraint])
    }
    
    func setUpPageController() {
        let topConstraint     = NSLayoutConstraint(item: PageControl, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: view.center.y + 70)
        let leadingConstraint = NSLayoutConstraint(item: PageControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25)
        let widthConstraint   = NSLayoutConstraint(item: PageControl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 75)
        let heightConstraint  = NSLayoutConstraint(item: PageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12)
        NSLayoutConstraint.activate([topConstraint,leadingConstraint,widthConstraint,heightConstraint])
    }
    
    func setUpNextButton() {
        var bottomConstraint = NSLayoutConstraint()
        if #available(iOS 11.0, *) {
            bottomConstraint = NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -54)
        } else {
            bottomConstraint = NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -54)
        }
        let widthConstraint  = NSLayoutConstraint(item: nextButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        let heightConstraint = NSLayoutConstraint(item: nextButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)
        let centerXAnchor    =  NSLayoutConstraint(item: nextButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([bottomConstraint,widthConstraint,heightConstraint,centerXAnchor])
    }
    
    //============================================================================
    //MARK: OnBoarding Setup functions
    //============================================================================
    
    func createSlides() -> [viewSlide] {
        
        let slide1 = viewSlide()
        slide1.titleLabel.text = "Wallet"
        slide1.descLabel.text = "Track your budget & store key documents like ID’s, visas, insurances and more all in one place!"
        
        let slide2 = viewSlide()
        slide2.titleLabel.text = "Lens"
        slide2.descLabel.text = "Use our LENS to hover over any amount and get an instant currency conversion in real-time!"
        
        let slide3 = viewSlide()
        slide3.titleLabel.text = "Haggle"
        slide3.descLabel.text = "Our HAGGLE tool will help you negotiate better prices & pay with Google Pay or Apple Pay!"
        
        return [slide1, slide2, slide3]
    }
    func setupSlideScrollView(slides : [viewSlide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x/scrollView.frame.size.width)
        PageControl.currentPage = Int(pageNumber)
        buttonTag = Int(pageNumber) + 1
    }
}

extension OnBoardingScreens: UIScrollViewDelegate{
    
    @objc func rightButtonTapped(tag : Int) {
        switch tag {
        case SelectedButtonTag.First.rawValue:
            scrollView.scrollToPage(index: UInt8(SelectedButtonTag.First.rawValue), animated: true, after: 0.1)
        case SelectedButtonTag.Second.rawValue:
            scrollView.scrollToPage(index: UInt8(SelectedButtonTag.Second.rawValue), animated: true, after: 0.1)
        default:
            setRootController()
        }
    }
    func setRootController(){
        StrongBoxController.sharedInstance.storeUserDefault(data: true, storeType: "HomePagePopUp")
        StrongBoxController.sharedInstance.storeUserDefault(data: true, storeType: "HomePage")
        let mainViewController = storyboardViewControllerFromString("HomeViewController")
        let leftViewController = storyboardViewControllerFromString("LeftViewController")
        let slideMenuController = ExSlideMenuController(mainViewController: mainViewController!, leftMenuViewController: leftViewController!)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
        navigationController?.pushViewController(slideMenuController, animated: true)
    }
    
}
extension UIScrollView {
    func scrollToPage(index: UInt8, animated: Bool, after delay: TimeInterval) {
        let offset: CGPoint = CGPoint(x: CGFloat(index) * frame.size.width, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.setContentOffset(offset, animated: animated)
        })
    }
}
enum SelectedButtonTag: Int {
    case First = 1
    case Second = 2
}

