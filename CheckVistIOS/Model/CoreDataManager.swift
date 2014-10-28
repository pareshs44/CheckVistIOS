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
  var alamofireManager : AlamofireManager!
  init(appContexts : AppManagedObjectContexts, tokenManager: APITokenManager) {
    self.appContexts = appContexts
    self.alamofireManager = AlamofireManager(tokenManager: tokenManager)
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
          let listDictionary = list as NSDictionary
          let bgContext = self.appContexts.backgroundContext
          bgContext.performBlock() {
            List.insertOrUpdate(listDictionary, managedObjectContext:bgContext)
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
          let taskDictionary = task as NSDictionary
          let bgContext = self.appContexts.backgroundContext
          bgContext.performBlock() {
            Task.insertOrUpdate(taskDictionary, managedObjectContext: bgContext)
            bgContext.save(nil)
          }
        }
      }
    }
  }
  
  func closeTaskItemWith(#listID: String, taskID: String) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    alamofireManager.closeTaskWith(listID: listID, taskID: taskID) {
      (response) in
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      let tasks = response as? NSArray
      if tasks != nil {
        for task in tasks! {
          let taskDictionary = task as NSDictionary
          let bgContext = self.appContexts.backgroundContext
          bgContext.performBlock() {
            Task.insertOrUpdate(taskDictionary, managedObjectContext: bgContext)
            bgContext.save(nil)
          }
        }
      }
    }
  }
  
}
