//
//  ALFBStaticTextViewCell.swift
//  Puls
//
//  Created by Aleksey Lobanov on 26/06/2017.
//  Copyright © 2017 Aleksey Lobanov. All rights reserved.
//

import UIKit

open class ALFBStaticTextViewCell: UITableViewCell, RxCellReloadeble {
  
  @IBOutlet weak var titleInfoLabel: UILabel!
  @IBOutlet weak var highlitedBackground: UIView!
  private var alreadyInitialized = false
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    highlitedBackground.alpha = 0
    self.layoutIfNeeded()
  }
  
  open override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if !selected {
      return
    }
    
    highlitedBackground.alpha = 1
    UIView.animate(withDuration: 0.3) { 
      self.highlitedBackground.alpha = 0
    }
  }

  public func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let formModel = model as? RowCustomCompositeOutput else {
      return
    }
    titleInfoLabel.text = formModel.data as? String ?? ""
    titleInfoLabel.isEnabled = !formModel.visible.isDisabled
    titleInfoLabel.alpha = formModel.visible.isDisabled ? 0.3 : 1
    
    if !alreadyInitialized {
      alreadyInitialized = true
      accessoryType = UITableViewCellAccessoryType.none
    }
    
    accessibilityIdentifier = formModel.identifier
    accessibilityValue = titleInfoLabel.text
  }
}
