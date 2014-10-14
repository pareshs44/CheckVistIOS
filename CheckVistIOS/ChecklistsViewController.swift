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
    refresh()
  }
  
  override func taskFetchRequest() -> NSFetchRequest {
    let fetchRequest = NSFetchRequest(entityName: "List")
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    return fetchRequest
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("listsCell")! as UITableViewCell
    let list = fetchedResultController.objectAtIndexPath(indexPath) as List
    cell.textLabel!.text = list.name
    return cell
  }
  
  func refresh() {
    let manager = AlamofireManager(appContexts: appContexts)
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    manager.getLists() {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let taskViewController = segue.destinationViewController as TasksViewController
    let senderCell = sender! as UITableViewCell
    let indexPath = self.tableView.indexPathForCell(senderCell)!
    let list = fetchedResultController.objectAtIndexPath(indexPath) as List
    taskViewController.listID = list.id
    taskViewController.appContexts = self.appContexts
  }
}