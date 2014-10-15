//
//  NFRCTableViewController.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/14/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import UIKit
import CoreData

class NFRCTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  var fetchedResultController: NSFetchedResultsController!
  var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchedResultController = getFetchedResultController()
    fetchedResultController.delegate = self
    fetchedResultController.performFetch(nil)
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return fetchedResultController.sections!.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultController.sections![section].numberOfObjects
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController!) {
    tableView.reloadData()
  }
  
  func getFetchedResultController() -> NSFetchedResultsController {
    var mainContext = self.appDelegate.appContexts.mainContext
    fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultController
  }
  
  func taskFetchRequest() -> NSFetchRequest {
    fatalError("This method must be overridden")
  }
  
}
