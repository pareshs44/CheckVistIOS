//
//  ChecklistsViewController.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/13/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import UIKit
import CoreData

class ChecklistsViewController: NFRCTableViewController {
  var appContexts: AppManagedObjectContexts!

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    CoreDataManager(appContexts: appContexts).refreshLists()
  }
  
  override func taskFetchRequest() -> NSFetchRequest {
    let fetchRequest = NSFetchRequest(entityName: "List")
    let sortDescriptor = NSSortDescriptor(key: "lastUpdated", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    return fetchRequest
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("listsCell")! as ListsTableViewCell
    let list = fetchedResultController.objectAtIndexPath(indexPath) as List
    cell.titleLabel!.text = list.name
    var progress:Float = 0.0
    if list.totalTasks > 0 {
      progress = list.tasksCompleted / list.totalTasks
    }
    cell.progressBar.setProgress(progress, animated: true)
    var rem = list.totalTasks.doubleValue - list.tasksCompleted.doubleValue
    cell.remainingTasks!.text = "\(list.totalTasks.integerValue - list.tasksCompleted.integerValue)"
    return cell
  }
  
  // Not completed right now.
  /*
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      NSLog("Trying to delete")
    } else {
      NSLog("Trying something else")
    }
  }
*/
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let taskViewController = segue.destinationViewController as TasksViewController
    let senderCell = sender! as UITableViewCell
    let indexPath = self.tableView.indexPathForCell(senderCell)!
    let list = fetchedResultController.objectAtIndexPath(indexPath) as List
    taskViewController.listID = list.id
    taskViewController.appContexts = self.appContexts
  }
  
  // Not completed
  @IBAction func addList(sender: UIBarButtonItem) {
    
  }
}