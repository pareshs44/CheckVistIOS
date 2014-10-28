//
//  SignInManager.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/21/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation

class APITokenManager {
  let appContexts : AppManagedObjectContexts
  
  init(appContexts: AppManagedObjectContexts) {
    self.appContexts = appContexts
  }
  
  func isSignedIn() -> Bool {
    let token = APIToken.tokenIn(managedObjectContext: appContexts.mainContext)
    if token != nil {
      return true
    } else {
      return false
    }
  }
  
  /** 
  This method should be called only after a call to `isSignedIn()` returns true.
  So we can be sure that the `token` we get in here is never `nil` 
  */
  func isTokenValid() -> Bool {
    let token = APIToken.tokenIn(managedObjectContext: appContexts.mainContext)
    if token!.expiry.timeIntervalSinceNow > 0 {
      return true
    } else {
      return false
    }
  }
  
  /**
  This method should be called only after a call to `isSignedIn()` returns true.
  So we can be sure that the `token` we get in here is never `nil`
  */
  func getAPIToken() -> String {
    let token = APIToken.tokenIn(managedObjectContext: appContexts.mainContext)
    return token!.tokenKey
  }
  
  func setAPITokenWith(#tokenKey : String) {
    let bgContext = appContexts.backgroundContext
    bgContext.performBlock() {
      APIToken.insertOrUpdateTokenWith(tokenKey, managedObjectContext: bgContext)
      var error: NSError?
      bgContext.save(&error)
    }
  }
}