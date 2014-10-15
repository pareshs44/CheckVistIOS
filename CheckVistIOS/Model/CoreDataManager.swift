//
//  CoreDataManager.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/14/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
  var appContexts : AppManagedObjectContexts!
  let alamofireManager = AlamofireManager()
  init(appContexts : AppManagedObjectContexts) {
    self.appContexts = appContexts
    super.init()
  }
  
  func refreshLists() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    alamofireManager.getLists() {
      (response) in
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      let lists = response as? NSArray
      if lists != nil {
        for list in lists! {
          let bgContext = self.appContexts.backgroundContext
          bgContext.performBlock() {
            List.insertOrUpdate(list, managedObjectContext:bgContext)
            bgContext.save(nil)
          }
        }
      }
    }
  }
  
  func refreshTaksForListWith(ID: String) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    alamofireManager.getTasksForList(ID) {
      (response) in
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      let tasks = response as? NSArray
      if tasks != nil {
        for task in tasks! {
          let bgContext = self.appContexts.backgroundContext
          bgContext.performBlock() {
            Task.insertOrUpdate(task, managedObjectContext: bgContext)
            bgContext.save(nil)
          }
        }
      }
    }
  }
  
}
