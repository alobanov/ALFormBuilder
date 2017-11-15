//
//  ALFBTextMultilineViewCell.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit

public protocol TableReloadable {
  var reload: (() -> Void)? {set get}
}

open class ALFBTextMultilineViewCell: UITableViewCell, RxCellReloadeble, UITextViewDelegate, TableReloadable {
  
  public var reload: (() -> Void)?
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var titleLabel: UILabel!
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    textView.textColor = ALFBStyle.fbDarkGray
    titleLabel.textColor = ALFBStyle.fbDarkGray
    textView.delegate = self
  }
  
  open override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  public func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let vm = model as? RowFormTextCompositeOutput else {
      return
    }
    textView.text = vm.value.transformForDisplay() ?? ""
    textView.isEditable = !vm.visible.isDisabled
    titleLabel.text = vm.visualisation.placeholderTopText
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    DispatchQueue.main.async {
      self.reload?()
    }
  }
}
