//
//  AppDelegate.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 9/24/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import UIKit
import CoreData

struct AppManagedObjectContexts {
  let mainContext: NSManagedObjectContext
  let backgroundContext: NSManagedObjectContext
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow!
  
  lazy var coreDataStore: CoreDataStore = {
    let coreDataStore = CoreDataStore()
    return coreDataStore
    }()
  
  lazy var coreDataHelper: CoreDataHelper = {
    let coreDataHelper = CoreDataHelper(store: self.coreDataStore)
    return coreDataHelper
    }()
  
  lazy var appContexts: AppManagedObjectContexts = {
    let appContexts = AppManagedObjectContexts(mainContext: self.coreDataHelper.mainManagedObjectContext!, backgroundContext: self.coreDataHelper.backgroundManagedObjectContext!)
    return appContexts
    }()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window.backgroundColor = UIColor.whiteColor()
    
    var rootViewController: UIViewController
    let tokenManager = APITokenManager(appContexts: appContexts)
    if tokenManager.isSignedIn() {
      let navigationController = mainStoryBoard.instantiateViewControllerWithIdentifier("MainNavigation") as UINavigationController
      let listViewController = navigationController.viewControllers[0] as ChecklistsViewController
      listViewController.appContexts = appContexts
      listViewController.tokenManager = tokenManager
      rootViewController = navigationController
    } else {
      let signInViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SignInViewController") as SignInViewController
      signInViewController.appContexts = appContexts
      signInViewController.tokenManager = tokenManager
      rootViewController = signInViewController
    }

    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    coreDataHelper.saveContext()
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    coreDataHelper.saveContext()
  }
}
