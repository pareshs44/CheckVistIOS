//
//  SignInTextField.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/10/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import Foundation
import UIKit

class SignInTextField: UITextField {
  let textFieldTextInset: CGFloat = 12.0
  override func textRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, textFieldTextInset, textFieldTextInset)
  }
  
  override func editingRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, textFieldTextInset, textFieldTextInset)
  }
}
