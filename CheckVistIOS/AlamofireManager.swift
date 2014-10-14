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
  let appContexts: AppManagedObjectContexts
  let baseURL = "http://checkvist.com/"
  let userDefaults = NSUserDefaults.standardUserDefaults()
  
  init(appContexts:AppManagedObjectContexts) {
    self.appContexts = appContexts
    super.init()
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
      if let token: AnyObject = response {
        self.userDefaults.setObject(token, forKey: "token")
        println(self.userDefaults.stringForKey("token"))
        completion()
      }
    }
  }
  
  func getLists(completion:()-> Void) {
    let checkListsPath = "checklists.json"
    if let token = userDefaults.stringForKey("token") {
      let params = ["token": token]
      let request = Alamofire.request(.GET, urlFor(checkListsPath), parameters: params)
      request.responseJSON {
        (_, _, response, error) in
        if let listsError = error {
          NSLog("Got error while fetching lists: %@", listsError)
        }
        let lists = response as? NSArray
        if lists != nil {
          for list in lists! {
            println(list)
            let bgContext = self.appContexts.backgroundContext
            bgContext.performBlock() {
              let listID = (list["id"] as NSNumber).stringValue
              var listIem = List.listWith(ID: listID, managedObjectContext:bgContext) as List
              listIem.name = list["name"]! as String
              listIem.tasksCompleted = list["task_completed"]! as NSNumber
              listIem.totalTasks = list["task_count"]! as NSNumber
//              listIem.lastUpdated = list["updated_at"]! as String
              println("CHICO")
              bgContext.save(nil)
            }
          }
        }
        completion()
      }
    }
  }
  
  func getTasksForList(id : String, completion:()-> Void) {
    let tasksPath = "checklists/"+id+"/tasks.json"
    NSLog(tasksPath)
    if let token = userDefaults.stringForKey("token") {
      let params = ["token": token]
      let request = Alamofire.request(.GET, urlFor(tasksPath), parameters: params)
      request.responseJSON {
        (_, _, response, error) in
        if let listsError = error {
          NSLog("Got error while fetching tasks: %@", listsError)
        }
        let tasks = response as? NSArray
        if tasks != nil {
          for task in tasks! {
            println(task)
            let bgContext = self.appContexts.backgroundContext
            bgContext.performBlock() {
              let taskID = (task["id"] as NSNumber).stringValue
              let listID = (task["checklist_id"] as NSNumber).stringValue
              var taskIem = Task.taskWith(ID: taskID, managedObjectContext:bgContext) as Task
              taskIem.list = List.listWith(ID: listID, managedObjectContext: bgContext) as List
//              listIem.name = list["name"]! as String
//              listIem.tasksCompleted = list["task_completed"]! as NSNumber
//              listIem.totalTasks = list["task_count"]! as NSNumber
//              listIem.lastUpdated = list["updated_at"]! as NSDate
              println("CHICO")
              bgContext.save(nil)
            }
          }
        }
        completion()
      }
    }
  }
}
