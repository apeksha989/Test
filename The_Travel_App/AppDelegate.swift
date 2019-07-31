//
//  AppDelegate.swift
//  Haggle
//
//  Created by Anil Kumar on 31/01/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import TwitterKit
import Stripe
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var background: UIBackgroundTaskIdentifier?
  var AlertViewC : PopUp?
  var DimViewC: UIView?
  
  lazy var storyBoard = UIStoryboard(name: "Main", bundle: nil)
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    debugPrint("<---------Welcome to TravelApp------------>😀")
    
    UIApplication.shared.applicationIconBadgeNumber = 0
    
    NotificationController.shared.registerLocalNotification()
    Stripe.setDefaultPublishableKey(Key.Stripe.StripPublishableKey)
    FirebaseApp.configure()
    GIDSignIn.sharedInstance().clientID = Key.googleClientID.ClientID

    GIDSignIn.sharedInstance().delegate = self
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    TWTRTwitter.sharedInstance().start(withConsumerKey: Key.Twitter.ConsumerKey, consumerSecret: Key.Twitter.consumerSecret)
    
    // Code added by AIT - iOS, Date - 02-05-2019, Release - Tesla, Desc - Whenever app is installed as new, saved  keychain values should be removed.
    if !UserDefaults.standard.bool(forKey: "hasRunBefore") {
      // reset strongbox
      UserDetails.destroy()
      StrongBoxController.sharedInstance.removeValuesFromStrongBox()
      UserDefaults.standard.set(true, forKey: "hasRunBefore")
    }
    
    
    let boolValue = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "HomePage")as? Bool
    
    if boolValue != nil {
        if let data = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "countryAndCodeAndIcon")as? [String:[String]] {
            UserDetails.countryAndCodeAndIcon = data
        }
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let leftViewController = storyBoard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let slideMenuController = ExSlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.navigationController?.navigationBar.isHidden = true
        slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
        self.window?.rootViewController = UINavigationController(rootViewController: slideMenuController)
        self.window?.makeKeyAndVisible()
    }else{
        let navigationController = UINavigationController(rootViewController: SocialMediaViewController())
        window?.rootViewController = navigationController
    }
    return true
  }
  
  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    let directedByGGL =  GIDSignIn.sharedInstance().handle(url as URL?,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    let directedByTWTR =  TWTRTwitter.sharedInstance().application(application, open: url, options: options)
    let directedByFB = ApplicationDelegate.shared.application(application, open: url, options: options)
    
    return directedByGGL || directedByTWTR || directedByFB
  }
  
  func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
    if (extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard) {
      return false
    }
    return true
  }
  
  func application(_ application: UIApplication,open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    var handle: Bool = true
    
    let options: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject, UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
    handle = TWTRTwitter.sharedInstance().application(application, open: url, options: options)
    return handle
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  deinit {
    print("Destroying instance of Appdelegate")
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    VideoBackground.shared.pause()

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    VideoBackground.shared.resume()
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    VideoBackground.shared.resume()        
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func getBatchCountNotification(){
//    if let notificationArrayRetrival = StrongBoxController.sharedInstance.retriveUserDefaultValues(RetriveKey: "notificationArray") as? [[String]] {
//      if !notificationArrayRetrival.isEmpty && (notificationArrayRetrival.count != 0){
//        UIApplication.shared.applicationIconBadgeNumber = notificationArrayRetrival.count
//      }
//    }else{
//      UIApplication.shared.applicationIconBadgeNumber = 0
//    }
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    UserDetails.delegateFlag = false
    StrongBoxController.sharedInstance.storeUserDefault(data: UserDetails.delegateFlag, storeType: "delegateFlag")
    print("WillTerminate")
    
    self.saveContext()
  }
  
  func newWindow(title: String, message: String, buttonTitle: String, controller: UIViewController){
    let window = UIApplication.shared.keyWindow!
    DimViewC = UIView(frame: window.bounds)
    window.addSubview(DimViewC!)
    DimViewC?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    AlertViewC = PopUp(title: title, message: message, buttonTitle: buttonTitle, controller:controller, frame: CGRect(x: 20.0, y: DimViewC!.frame.size.height/4, width: DimViewC!.frame.size.width - 40, height: DimViewC!.frame.size.height/3))
    AlertViewC?.backgroundColor = UIColor.white
    AlertViewC?.delegate = controller as? popUDelegate
    DimViewC?.addSubview(AlertViewC!)
  }
  
  func removeAllViews(){
    AlertViewC?.removeFromSuperview()
    DimViewC?.removeFromSuperview()
  }
  
  
  func dobackground(){
    beginbackground()
    let queue = DispatchQueue.global(qos:.background)
    queue.async {
      sleep(20)
      self.endbackground()
    }
  }
  func beginbackground(){
    background = UIApplication.shared.beginBackgroundTask(withName:"downloading"){
      self.endbackground()
    }
  }
  func endbackground(){
    
    background = UIApplication.shared.beginBackgroundTask(withName: "download")
    UIApplication.shared.endBackgroundTask(background!)
    background = UIBackgroundTaskIdentifier.invalid
  }
  
  func getCurrentViewController(_ vc: UIViewController) -> UIViewController? {
    if let presentViewControllers = vc.presentedViewController {
      return getCurrentViewController(presentViewControllers)
    }
    else if let splitViewControllers = vc as? UISplitViewController, splitViewControllers.viewControllers.count > 0 {
      return getCurrentViewController(splitViewControllers.viewControllers.last!)
    }
    else if let navigationControllers = vc as? UINavigationController, navigationControllers.viewControllers.count > 0 {
      return getCurrentViewController(navigationControllers.topViewController!)
    }
    else if let tabBarViewControllers = vc as? UITabBarController {
      if let selectedViewController = tabBarViewControllers.selectedViewController {
        return getCurrentViewController(selectedViewController)
      }
    }
    return vc
  }
  
  
  public func alertCallRootController(title: String,message: String){
    let rootController = UINavigationController()
    guard let rootViewControllers = self.window?.rootViewController else {
      return
    }
    if let viewControllers = getCurrentViewController(rootViewControllers) {
      weak var controller = viewControllers
      controller?.showConfirmAlert(title: title, message:message, buttonTitle: "OK", buttonStyle: .default) { (action) in
        rootController.popToRootViewController(animated: true)
      }
    }
  }
  
  public func currentViewController()-> UIViewController?{
    guard let rootViewControllers = self.window?.rootViewController else {
      return nil
    }
    if let viewControllers = getCurrentViewController(rootViewControllers) {
      weak var controller = viewControllers
      return controller
    }else{
      return nil
    }
  }
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "Haggle")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
}

extension AppDelegate : GIDSignInDelegate{
  // added public. Changes made by Apeksha
 public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if let error = error {
      alertCallRootController(title: "error",message: "\(error.localizedDescription)")
    } else {
      //            let userId = user.userID                  // For client-side use only!
      //            let idToken = user.authentication.idToken // Safe to send to the server
      //            let fullName = user.profile.name
      //            let givenName = user.profile.givenName
      //            let familyName = user.profile.familyName
      //            let email = user.profile.email
      // ...
    }
  }
     // added public changes made by Apeksha
public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,withError error: Error!) {
    alertCallRootController(title: "error",message: "\(error.localizedDescription)")
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
    completionHandler([.alert, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    
    if response.notification.request.identifier == "Expense Alert" {
      notificationTapping()
      print("Handling notifications with the Local Notification Expense Alert")
    }else{
      notificationTapping()
      print("Handling notifications with the Local Notification Budget Alert")
    }
    
    completionHandler()
  }
  
  func notificationTapping(){
    guard let rootViewControllers = self.window?.rootViewController else {
      return
    }
    if let viewControllers = getCurrentViewController(rootViewControllers) {
      viewControllers.popOrPushToViewController("NotificationsScreen")
    }
  }
  
  func getNotficatioScreen(){
    
    let mainViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    let leftViewController = storyBoard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
    let slideMenuController = ExSlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)
    slideMenuController.automaticallyAdjustsScrollViewInsets = true
    slideMenuController.navigationController?.navigationBar.isHidden = true
    slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
    self.window?.rootViewController = UINavigationController(rootViewController: slideMenuController)
    self.window?.makeKeyAndVisible()
  }
}
