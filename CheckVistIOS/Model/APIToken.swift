//
//  APIToken.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/21/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation
import CoreData

let TokenExpiryInSeconds = 86400.0

@objc(APIToken)
class APIToken: NSManagedObject {
  
  @NSManaged var expiry: NSDate
  @NSManaged var tokenKey: String
  
  class func tokenIn(#managedObjectContext: NSManagedObjectContext) -> APIToken? {
    let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(self))
    var error : NSError? = nil
    if let results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
      if results.count > 0 {
        let token = results.last as APIToken
        return token
      }
    }
    return nil
  }
  
  class func insertOrUpdateTokenWith(tokenKey:String, managedObjectContext:NSManagedObjectContext) {
    var token: APIToken! = APIToken.tokenIn(managedObjectContext: managedObjectContext)
    if token == nil {
      token = NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(self), inManagedObjectContext: managedObjectContext) as APIToken
    }
    token.tokenKey = tokenKey
    token.expiry = NSDate(timeIntervalSinceNow: TokenExpiryInSeconds)
  }
}
