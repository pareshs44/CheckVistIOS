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
  var tokenManager: APITokenManager!
  
  @IBOutlet weak var emailAddressTextField: SignInTextField!
  @IBOutlet weak var passwordTextField: SignInTextField!
  
  @IBAction func signIn(sender: UIButton) {
    if let userEmailId = emailAddressTextField.text {
      if let password = passwordTextField.text {
        signInWith(emailID: userEmailId, password: password)
      }
    }
  }
  
  func signInWith(#emailID: String, password: String) {
    let alamofireManager = AlamofireManager(tokenManager: tokenManager)
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    alamofireManager.signInWithEmailId(emailID, password: password) {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavigation") as UINavigationController
      let listViewController = navigationController.viewControllers[0] as ChecklistsViewController
      listViewController.appContexts = self.appContexts
      listViewController.tokenManager = self.tokenManager
      
      self.presentViewController(navigationController, animated: true, completion: nil)
    }
  }
}