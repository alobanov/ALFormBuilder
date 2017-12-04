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
  fileprivate var storedModel: RowFormTextCompositeOutput?
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    textView.textColor = ALFBStyle.fbDarkGray
    titleLabel.textColor = ALFBStyle.fbDarkGray
    textView.delegate = self
  }
  
  public func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let vm = model as? RowFormTextCompositeOutput else {
      return
    }
    storedModel = vm
    let newText = vm.value.transformForDisplay()
    if textView.text != newText {
      textView.text = vm.value.transformForDisplay() ?? ""
    }
    let isEditable = !vm.visible.isDisabled
    if textView.isEditable != isEditable {
      textView.isEditable = isEditable
    }
    titleLabel.text = vm.visualisation.placeholderTopText
  }
  
  public func textViewDidChange(_ textView: UITextView) {
//    DispatchQueue.main.async {
//      self.storedModel?.update(value: ALStringValue(value: textView.text))
////      self.reload?()
//    }
    storedModel?.update(value: ALStringValue(value: textView.text), silent: true)
//    storedModel?.update(value: ALStringValue(value: textView.text))
  }
}
