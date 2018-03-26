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
  private var maxLength: Int?
  private var placeholder: String = ""
  
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
    self.maxLength = self.storedModel.validation.maxLength
    self.placeholder = vm.visualisation.placeholderText
    
    let newText = vm.value.transformForDisplay()
    if textView.text != newText {
      textView.text = vm.value.transformForDisplay() ?? ""
    }
    let isEditable = !vm.visible.isDisabled
    if textView.isEditable != isEditable {
      textView.isEditable = isEditable
    }
    titleLabel.text = vm.visualisation.placeholderTopText
    if textView.text.isEmpty {
      textView.text = placeholder
      textView.textColor = UIColor.lightGray
    }
    
    // Configurate next only one
    if !alreadyInitialized {
      configureRx()      
      alreadyInitialized = true
    }
    
    textView.accessibilityIdentifier = vm.identifier
    textView.accessibilityLabel = textView.text
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
  
  // MARK: - UITextViewDelegate
  
  public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if let max = maxLength {
      var newText = (textView.text as NSString).replacingCharacters(in: range, with: text).trim()
      if newText == placeholder {
        newText = ""
      }
      let numberOfChars = newText.count
      if numberOfChars > max {
        if text.count > 1 {
          let lastIndex = newText.index(newText.startIndex, offsetBy: max)
          textView.text = String(newText[..<lastIndex])
        }
        return false
      } else {
        return true
      }
    } else {
      return true
    }
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    DispatchQueue.main.async {
      self.reload?()
    }
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    let text = textView.text.trim()
    if text == placeholder {
      textView.text = ""
      textView.textColor = UIColor.black
    }
    textView.becomeFirstResponder()
    self.storedModel.base.changeisEditingNow(true)
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    let text = textView.text.trim()
    if text.isEmpty {
      textView.text = placeholder
      textView.textColor = UIColor.lightGray
    }
    textView.resignFirstResponder()
  }
  
}
