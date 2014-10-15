//
//  AlamofireManager.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/11/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class AlamofireManager: NSObject {
  let tokenExpiryInSeconds = 86400.0
  let baseURL = "http://checkvist.com/"
  let userDefaults = NSUserDefaults.standardUserDefaults()
  
  func getToken(completion:(token:String) -> Void) {
    let expiryDate = userDefaults.objectForKey("tokenExpiry") as NSDate
    if expiryDate.timeIntervalSinceNow > 0 {
      let token = userDefaults.stringForKey("token")!
      completion(token: token)
    } else {
      refreshToken(completion)
    }
  }
  
  func refreshToken(completion:(token: String) -> Void) {
    let refreshTokenPath = "auth/refresh_token.json"
    let params = ["old_token": userDefaults.stringForKey("token")!]
    let request = Alamofire.request(.GET, urlFor(refreshTokenPath), parameters: params)
    request.responseJSON {
      (_, _, response, error) in
      if let refreshTokenError = error {
        NSLog("Got error while refreshing token: %@", refreshTokenError)
      }
      if let token = response as? String {
        self.userDefaults.setObject(token, forKey: "token")
        self.userDefaults.setObject(NSDate(timeIntervalSinceNow: self.tokenExpiryInSeconds), forKey: "tokenExpiry")
        completion(token: token)
      }
    }
  }
  
  func urlFor(path: String) -> URLStringConvertible {
    return NSURL(string: path, relativeToURL: NSURL(string: baseURL)).absoluteString!
  }
  
  func signInWithEmailId(emailId: String, password remoteKey: String, completion:()-> Void) {
    let signInPath = "auth/login.json"
    let params = ["username": emailId, "remote_key": remoteKey]
    let request = Alamofire.request(.GET, urlFor(signInPath), parameters: params)
    request.responseJSON {
      (_, _, response, error) in
      if let signInError = error {
        NSLog("Got sign in error: %@", signInError)
      }
      if let token = response as? String {
        self.userDefaults.setObject(token, forKey: "token")
        self.userDefaults.setObject(NSDate(timeIntervalSinceNow: self.tokenExpiryInSeconds), forKey: "tokenExpiry")
        completion()
      }
    }
  }
  
  func getLists(completion:(response : AnyObject?)-> Void) {
    let checkListsPath = "checklists.json"
    getToken() {
      (token) in
      let params = ["token": token]
      let request = Alamofire.request(.GET, self.urlFor(checkListsPath), parameters: params)
      request.responseJSON {
        (_, _, response, error) in
        if let listsError = error {
          NSLog("Got error while fetching lists: %@", listsError)
        }
        completion(response: response)
      }
    }
  }
  
  func getTasksForList(id : String, completion:(response : AnyObject?)-> Void) {
    let tasksPath = "checklists/"+id+"/tasks.json"
    getToken() {
      (token) in
      let params = ["token": token]
      let request = Alamofire.request(.GET, self.urlFor(tasksPath), parameters: params)
      request.responseJSON {
        (_, _, response, error) in
        if let listsError = error {
          NSLog("Got error while fetching tasks: %@", listsError)
        }
        completion(response: response)
      }
    }
  }
  
}
