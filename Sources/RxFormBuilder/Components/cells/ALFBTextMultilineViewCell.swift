//
//  ALFBTextMultilineViewCell.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol TableReloadable {
  var reload: (() -> Void)? {set get}
}

open class ALFBTextMultilineViewCell: UITableViewCell, RxCellReloadeble, UITextViewDelegate, TableReloadable {
  
  public var reload: (() -> Void)?
  let bag = DisposeBag()
  
  fileprivate var alreadyInitialized = false
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var titleLabel: UILabel!
  fileprivate var storedModel: RowFormTextCompositeOutput!
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    textView.textColor = ALFBStyle.fbDarkGray
    titleLabel.textColor = ALFBStyle.fbDarkGray
    textView.delegate = self
    
    self.layoutIfNeeded()
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
    
    
    // Configurate next only one
    if !alreadyInitialized {
      configureRx()      
      alreadyInitialized = true
    }
  }
  
  
  func configureRx() {
    // Check validation all of text stream
    textView.rx.text.asDriver().skip(1)
      .filter({ [weak self] text -> Bool in
        return (text != self?.storedModel.value.transformForDisplay())
      }).drive(onNext: { [weak self] text in
        self?.storedModel.update(value: ALStringValue(value: text))
      }).disposed(by: bag)
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    self.storedModel.base.changeisEditingNow(true)
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    DispatchQueue.main.async {
      self.reload?()
    }
  }
}
