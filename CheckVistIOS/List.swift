//
//  List.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/13/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation
import CoreData

@objc(List)
class List: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var totalTasks: NSNumber
    @NSManaged var tasksCompleted: NSNumber
    @NSManaged var lastUpdated: NSDate
    @NSManaged var tasks: NSSet

  class func listWith(#ID:String, managedObjectContext:NSManagedObjectContext) -> List {
    let predicate = NSPredicate(format: "id == %@", ID)
    let fetchRequest = NSFetchRequest(entityName: "List")
    fetchRequest.predicate = predicate
    fetchRequest.returnsObjectsAsFaults = false
    
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
}
