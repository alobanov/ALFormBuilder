//
//  FormButtonViewCell.swift
//  Puls
//
//  Created by MOPC on 26/06/2017.
//  Copyright © 2017 MOPC. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ALFBButtonViewCell: UITableViewCell, RxCellReloadeble {

  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var highlitedBackground: UIView!
  
  private var storedModel: RowFormButtonCompositeOutput!
  private var alreadyInitialized = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    highlitedBackground.alpha = 0
    layoutIfNeeded()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if !selected {
      return
    }
    
    highlitedBackground.alpha = 1
    UIView.animate(withDuration: 0.3) {
      self.highlitedBackground.alpha = 0
    }
  }
  
  func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let formModel = model as? RowFormButtonCompositeOutput else {
      return
    }
    
    actionButton.setTitle(formModel.title, for: UIControlState.normal)
    actionButton.alpha = formModel.visible.isDisabled ? 0.3 : 1
    self.isUserInteractionEnabled = !formModel.visible.isDisabled
    
    if !alreadyInitialized {
      alreadyInitialized = true
      accessoryType = UITableViewCellAccessoryType.none
    }
  }
}
