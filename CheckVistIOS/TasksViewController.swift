//
//  TasksViewController.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/13/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TasksViewController : NFRCTableViewController {
  
  var appContexts: AppManagedObjectContexts!
  var listID: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refresh()
  }
  
  override func taskFetchRequest() -> NSFetchRequest {
    let fetchRequest = NSFetchRequest(entityName: "Task")
    fetchRequest.predicate = NSPredicate(format: "list.id = %@", listID!)
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    return fetchRequest
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("taskCell")! as UITableViewCell
    let task = fetchedResultController.objectAtIndexPath(indexPath) as Task
    cell.textLabel!.text = task.id
    return cell
  }
  
  func refresh() {
    let manager = AlamofireManager(appContexts: appContexts!)
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    manager.getTasksForList(listID) {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
  }
}