//
//  List.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/15/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation
import CoreData

@objc(List)
class List: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var lastUpdated: String
    @NSManaged var name: String
    @NSManaged var tasksCompleted: NSNumber
    @NSManaged var totalTasks: NSNumber
    @NSManaged var tasks: NSSet

  class func listWith(#ID:String, managedObjectContext:NSManagedObjectContext) -> List {
    let predicate = NSPredicate(format: "id == %@", ID)
    let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(self))
    fetchRequest.predicate = predicate
    
    var error: NSError? = nil
    var list: List
    if var results = managedObjectContext.executeFetchRequest(fetchRequest, error:&error) {
      if results.count > 0 {
        list = results.last as List
      } else {
        list = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: managedObjectContext) as List
        list.id = ID
      }
    } else {
      list = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: managedObjectContext) as List
      list.id = ID
    }
    return list
  }
  
  class func insertOrUpdate(list:NSDictionary, managedObjectContext:NSManagedObjectContext) {
    let listID = (list["id"] as NSNumber).stringValue
    var listIem = List.listWith(ID: listID, managedObjectContext:managedObjectContext)
    listIem.name = list["name"]! as String
    listIem.tasksCompleted = list["task_completed"]! as NSNumber
    listIem.totalTasks = list["task_count"]! as NSNumber
    listIem.lastUpdated = list["updated_at"]! as String
  }
}
