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

class TasksViewController : UITableViewController, NSFetchedResultsControllerDelegate {
  
  var appContexts: AppManagedObjectContexts!
  var tokenManager: APITokenManager!
  var listID: String!
  var parentID: String!
  weak var switchButton: UISwitch!
  
  var fetchedResultsControllerForAllTasks: NSFetchedResultsController!
  var fetchedResultsControllerForCompletedTasks: NSFetchedResultsController!
  
  var dataSourceTotalTasks : [Task]!
  var dataSourceCompletedTasks: [Task]!
  
  lazy var fetchRequestForTotalTasks: NSFetchRequest = {
    let totalTasksPredicate = NSPredicate(format: "list.id = %@ and parentTaskID = %@", self.listID, self.parentID)
    return self.tasksFetchRequestWith(totalTasksPredicate)
    }()
  
  lazy var fetchRequestForCompletedTasks: NSFetchRequest = {
    let completedStatus = NSNumber(int: 1)
    let completedTasksPredicate = NSPredicate(format: "list.id = %@ and parentTaskID = %@ and status = %@", self.listID, self.parentID, completedStatus)
    return self.tasksFetchRequestWith(completedTasksPredicate)
    }()
  
  lazy var coreDataManager: CoreDataManager = {
    let coreDataManager = CoreDataManager(appContexts: self.appContexts, tokenManager: self.tokenManager)
    return coreDataManager
    }()
  
  func colorFor(#stringValue: String) -> UIColor {
    switch(stringValue) {
    case "red":
      return UIColor.redColor()
    case "green":
      return UIColor.greenColor()
    case "blue":
      return UIColor.blueColor()
    default:
      return UIColor.clearColor()
    }
  }
  
  override func viewDidLoad() {
    self.title = "Tasks"
    coreDataManager.refreshTaksForListWith(listID)
    let switchButton = UISwitch()
    switchButton.addTarget(self, action: "toggleTasks:", forControlEvents: .TouchUpInside | .TouchDragInside)
    self.switchButton = switchButton
    let switchButtonBarItem = UIBarButtonItem(customView: switchButton)
    self.navigationItem.rightBarButtonItem = switchButtonBarItem
    switchButton.on = true
    super.viewDidLoad()
  }
  
  func tasksFetchRequestWith(predicate: NSPredicate?) -> NSFetchRequest {
    let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(Task))
    if predicate != nil {
      fetchRequest.predicate = predicate!
    }
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    return fetchRequest
  }
  
  func getFetchRequest() -> NSFetchRequest {
    if switchButton.on {
      return fetchRequestForTotalTasks
    } else {
      return fetchRequestForCompletedTasks
    }
  }
  
  func getFetchedResultsController() -> NSFetchedResultsController {
    if switchButton.on {
      if fetchedResultsControllerForAllTasks != nil {
        return fetchedResultsControllerForAllTasks
      }
    } else {
      if fetchedResultsControllerForCompletedTasks != nil {
        return fetchedResultsControllerForCompletedTasks
      }
    }
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: getFetchRequest(), managedObjectContext: appContexts.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    fetchedResultsController.performFetch(nil)
    if switchButton.on {
      fetchedResultsControllerForAllTasks = fetchedResultsController
    } else {
      fetchedResultsControllerForCompletedTasks = fetchedResultsController
    }
    return fetchedResultsController
  }
  
  func toggleTasks(sender: UISwitch) {
    self.tableView.reloadData()
  }
  
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    self.tableView.reloadData()
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return getFetchedResultsController().sections!.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return getFetchedResultsController().sections![section].numberOfObjects
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("tasksCell") as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell()
    }
    let task = getFetchedResultsController().objectAtIndexPath(indexPath) as Task
    
    cell!.textLabel.text = task.name
    if task.dueDate != nil {
      cell!.detailTextLabel?.text = task.dueDate
    } else {
      cell!.detailTextLabel?.text = ""
    }
    if task.textColor != nil {
      cell!.textLabel.textColor = colorFor(stringValue: task.textColor!)
    }
    if task.backgroundColor != nil {
      cell!.contentView.backgroundColor = colorFor(stringValue: task.backgroundColor!)
    }
    return cell!
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let task = getFetchedResultsController().objectAtIndexPath(indexPath) as Task
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    let tasksViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("TasksViewController") as TasksViewController
    tasksViewController.appContexts = appContexts
    tasksViewController.tokenManager = tokenManager
    tasksViewController.listID = listID
    tasksViewController.parentID = task.id
    self.navigationController?.pushViewController(tasksViewController, animated: true)
  }
  
  @IBAction func completeTask(sender: UISwipeGestureRecognizer) {
    let location = sender.locationInView(tableView)
    let swipedIndexPath = tableView.indexPathForRowAtPoint(location)!
    let task = getFetchedResultsController().objectAtIndexPath(swipedIndexPath) as Task
    if task.status.integerValue == 0  {
      coreDataManager.closeTaskItemWith(listID: listID, taskID: task.id)
    }
  }
  
}
