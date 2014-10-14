//
//  Task.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/13/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation
import CoreData

@objc(Task)
class Task: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var priority: String
    @NSManaged var details: String
    @NSManaged var dueDate: NSDate
    @NSManaged var status: NSNumber
    @NSManaged var lastUpdated: NSDate
    @NSManaged var position: NSNumber
    @NSManaged var listID: String
    @NSManaged var list: List

  class func taskWith(#ID:String, managedObjectContext:NSManagedObjectContext) -> Task {
    let predicate = NSPredicate(format: "id == %@", ID)
    let fetchRequest = NSFetchRequest(entityName: "Task")
    fetchRequest.predicate = predicate
    fetchRequest.returnsObjectsAsFaults = false
    
    var error: NSError? = nil
    var task: Task
    if var results = managedObjectContext.executeFetchRequest(fetchRequest, error:&error) {
      if results.count > 0 {
        task = results.last as Task
      } else {
        task = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: managedObjectContext) as Task
        task.id = ID
      }
    } else {
      task = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: managedObjectContext) as Task
      task.id = ID
    }
    return task
  }
  
//  class func tasksForListWith(#ID: String, managedObjectContext: NSManagedObjectContext) -> [Task] {
//    let predicate = NSPredicate(format: "")
//    let fetchRequest = NSFetchRequest()
//  }

}
