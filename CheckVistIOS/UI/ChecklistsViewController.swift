//
//  ChecklistsViewController.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/13/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import UIKit
import CoreData

class ChecklistsViewController: UITableViewController, NSFetchedResultsControllerDelegate {

  var appContexts: AppManagedObjectContexts!
  var tokenManager: APITokenManager!
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetchRequest = NSFetchRequest(entityName: "List")
    let sortDescriptor = NSSortDescriptor(key: "lastUpdated", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.appContexts.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    var error : NSError?
    fetchedResultsController.performFetch(&error)
    return fetchedResultsController
  }()
  
  lazy var coreDataManager: CoreDataManager = {
    let coreDataManager = CoreDataManager(appContexts: self.appContexts, tokenManager: self.tokenManager)
    return coreDataManager
  }()
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    coreDataManager.refreshLists()
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return fetchedResultsController.sections!.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections![section].numberOfObjects
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController!) {
    tableView.reloadData()
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let list = fetchedResultsController.objectAtIndexPath(indexPath) as List
    var cell = tableView.dequeueReusableCellWithIdentifier("listsCell") as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell()
    }
    configure(cell: cell!, list: list)
    return cell!
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
  
  func configure(#cell: UITableViewCell, list: List) {
    var remainingTasks = list.totalTasks.integerValue - list.tasksCompleted.integerValue
    var detailsText = "remaining"
    switch remainingTasks {
    case 0:
      detailsText = "No task " + detailsText
    case 1:
      detailsText = "Only 1 task " + detailsText
    default:
      detailsText = "\(remainingTasks) tasks " + detailsText
    }
    cell.textLabel.text = list.name
    cell.detailTextLabel?.text = detailsText
    
//    var viewRect = CGRect(x: 0, y: 0, width: CGRectGetWidth(cell.frame), height: CGRectGetHeight(cell.frame))
//    var view = UIView(frame: viewRect)
//    
//    println("Pikahuc: %@", cell.contentView.subviews)
//    cell.backgroundColor = UIColor.clearColor()
//    var progress = CGFloat(list.tasksCompleted.floatValue / list.totalTasks.floatValue)
//    var barWidth = progress * cell.frame.size.width as NSNumber
//    var rect = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
//    var view = UIView(frame: rect)
//    view.backgroundColor = UIColor.blueColor()
//    cell.contentView.addSubview(view)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let taskViewController = segue.destinationViewController as TasksViewController
    let senderCell = sender! as UITableViewCell
    let indexPath = self.tableView.indexPathForCell(senderCell)!
    let list = fetchedResultsController.objectAtIndexPath(indexPath) as List
    taskViewController.listID = list.id
    taskViewController.parentID = "0"
    taskViewController.appContexts = appContexts
    taskViewController.tokenManager = tokenManager
  }
  
  // Not completed
  @IBAction func addList(sender: UIBarButtonItem) {
    
  }
}