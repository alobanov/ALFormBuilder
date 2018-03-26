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
  fileprivate var validationState: BehaviorSubject<ALFB.ValidationState>!
  fileprivate var didChangeValidation: DidChangeValidation!
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var validMark: UIImageView!
  @IBOutlet weak var validMarkWidth: NSLayoutConstraint!
  
  fileprivate var storedModel: RowFormTextCompositeOutput!
  private var maxLength: Int?
  private var placeholder: String = ""
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    textView.textColor = ALFBStyle.fbDarkGray
    titleLabel.textColor = ALFBStyle.fbDarkGray
    textView.delegate = self
    validMark.image = ALFBStyle.imageOfTfAlertIconStar
    
    self.didChangeValidation = { [weak self] _ in
      if let state = self?.storedModel.validation.state {
        self?.validationState.onNext(state)
      }
    }
    
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
    
    var display = vm.validation.state.isVisibleValidationUI
    if !validMark.isHidden {
      display = vm.visible.isMandatory
    }
    displayValidMark(display)
    
    if let s = self.storedModel {
      self.storedModel.didChangeValidation[s.identifier] = didChangeValidation
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
    
    textView.rx.didBeginEditing.asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.displayValidMark(false)
        self?.validMark.isHidden = true
      }).disposed(by: bag)
    
    self.validationState = BehaviorSubject<ALFB.ValidationState>(value: self.storedModel.validation.state)
    let endEditing = textView.rx.didEndEditing.asObservable().withLatestFrom(validationState)
    endEditing.subscribe(onNext: {[weak self] valid in
      self?.storedModel.base.changeisEditingNow(false)
      var hideValidMark = valid.isValidWithTyping
      let isMandatory = self?.storedModel.visible.isMandatory ?? false
      if !isMandatory {
        hideValidMark = !isMandatory
      }
      self?.displayValidMark(!hideValidMark)
    }).disposed(by: bag)
    
  }
  
  private func displayValidMark(_ display: Bool)  {
    validMark.isHidden = !display
    validMarkWidth.constant = validMark.isHidden ? 0 : 20.0
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
          textView.text = newText.substring(to: lastIndex)
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
