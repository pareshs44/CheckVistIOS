//
//  ListsTableViewCell.swift
//  CheckVistIOS
//
//  Created by Paresh Shukla on 10/14/14.
//  Copyright (c) 2014 Talk.to FZC. All rights reserved.
//

import UIKit

class ListsTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var progressBar: UIProgressView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
