//
//  Task.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/15/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation
import CoreData

@objc(Task)
class Task: NSManagedObject {

    @NSManaged var dueDate: String
    @NSManaged var id: String
    @NSManaged var lastUpdated: String
    @NSManaged var name: String
    @NSManaged var position: NSNumber
    @NSManaged var status: NSNumber
    @NSManaged var parentTaskID: String
    @NSManaged var isTaskDeleted: NSNumber
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
  
  class func insertOrUpdate(task: AnyObject, managedObjectContext: NSManagedObjectContext) {
    let taskID = (task["id"] as NSNumber).stringValue
    let listID = (task["checklist_id"] as NSNumber).stringValue
    var taskItem = Task.taskWith(ID: taskID, managedObjectContext:managedObjectContext) as Task
    taskItem.list = List.listWith(ID: listID, managedObjectContext: managedObjectContext) as List
    taskItem.name = task["content"]! as String
    if let taskDeleted = task["deleted"] as? Bool {
      taskItem.isTaskDeleted = taskDeleted
    }
    taskItem.lastUpdated = task["updated_at"]! as String
    taskItem.status = task["status"]! as NSNumber
    if let dueDate = task["due"] as? String {
      taskItem.dueDate = dueDate
    }
    taskItem.position = task["position"]! as NSNumber
    taskItem.parentTaskID = (task["parent_id"]! as NSNumber).stringValue
  }
}
