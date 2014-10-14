//
//  SignInViewController.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/10/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignInViewController: UIViewController {
  var appContexts: AppManagedObjectContexts!
  @IBOutlet weak var emailAddressTextField: SignInTextField!
  @IBOutlet weak var passwordTextField: SignInTextField!
  
  @IBAction func signIn(sender: UIButton) {
    if let userEmailId = emailAddressTextField.text {
      if let password = passwordTextField.text {
        let manager = AlamofireManager(appContexts:appContexts)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        manager.signInWithEmailId(userEmailId, password: password) {
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          
          let navigationController :UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavigation") as UINavigationController
          let listViewController = navigationController.viewControllers[0] as ChecklistsViewController
          listViewController.appContexts = self.appContexts
          self.presentViewController(navigationController, animated: true, completion: nil)
        }
      }
    }
  }
}