//
//  CoreDataHelper.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/14/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
 
  let store: CoreDataStore
  init(store: CoreDataStore) {
    self.store = store
    super.init()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidSaveContext:", name: NSManagedObjectContextDidSaveNotification, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  lazy var mainManagedObjectContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.store.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    mainContext.persistentStoreCoordinator = coordinator
    return mainContext
  }()
  
  lazy var backgroundManagedObjectContext: NSManagedObjectContext? = {
    let coordinator = self.store.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    backgroundContext.persistentStoreCoordinator = coordinator
    return backgroundContext
  }()
  
  // save NAManagedObjectContext
  func saveContext(context: NSManagedObjectContext) {
    var error: NSError? = nil
    if context.hasChanges && !context.save(&error) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(error), \(error!.userInfo)")
      abort()
    }
  }

  func saveContext() {
    self.saveContext(backgroundManagedObjectContext!)
  }
  
  // call back function by save context
  func contextDidSaveContext(notification: NSNotification) {
    NSLog("** Saved background Context in its thread")
    mainManagedObjectContext!.performBlock {
      self.mainManagedObjectContext!.mergeChangesFromContextDidSaveNotification(notification)
    }
  }
}
