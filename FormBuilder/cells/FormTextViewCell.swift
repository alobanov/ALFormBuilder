//
//  FormTextViewCell.swift
//  Plus
//
//  Created by MOPC on 15.03.17.
//  Copyright © 2017 MOPC Lab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FormTextViewCell: UITableViewCell, RxCellReloadeble, UITextFieldDelegate {
  
  @IBOutlet weak var textField: CCRegValidationTextField!
  @IBOutlet weak var descriptionValueLabel: UILabel!
  @IBOutlet weak var validateBtn: UIButton!
  @IBOutlet weak var cleareBtn: UIButton!
  @IBOutlet weak var errorHighlightView: UIView!
  
  fileprivate var storedModel: RowFormTextCompositeOutput!
  fileprivate var alreadyInitialized = false
  
  let bag = DisposeBag()
   
  override func awakeFromNib() {
    super.awakeFromNib()
    // base configuration
    validateBtn.setImage(PulsStyleKit.imageOfTfAlertIconStar, for: UIControlState())
    cleareBtn.setImage(PulsStyleKit.imageOfCloseBtn(customColor: UIColor.gray), for: UIControlState())
    
    errorHighlightView.alpha = 0
    errorHighlightView.isUserInteractionEnabled = false
    
    validateBtn.isHidden = true
    cleareBtn.isHidden = true
    clipsToBounds = true
    
    self.layoutIfNeeded()
  }
  
  func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let vm = model as? RowFormTextCompositeOutput else {
      return
    }
    
    // check type of model data
    switch vm.visualisation.dataType {
    case .string, .decimal, .integer, .password:
      self.storedModel = vm
    break
      default: return
    }
    
    // Configurate text field
    // keybord type
    textField.keyboardType = vm.visualisation.keyboardType.value
    
    // Additional placeholder above the input text
    textField.textPlaceholder = vm.visualisation.placeholderTopText
    textField.autocapitalizationType = vm.visualisation.autocapitalizationType.value
    
    // Just place holder
    textField.placeholder = vm.visualisation.placeholderText
    
    // Can editable
    textField.isUserInteractionEnabled = !vm.visible.isDisabled
    self.textField.textColor = textField.isUserInteractionEnabled
      ? UIColor.black
      : UIColor.lightGray
    
    self.backgroundColor = textField.isUserInteractionEnabled
      ? UIColor.white
      : UIColor.lightText
    
    // is password type
    textField.isSecureTextEntry = vm.visualisation.isPassword
    
    // Set value
    textField.text = vm.value.transformForDisplay() ?? ""
    
    // Fill by color for validation state
    textField.validate(vm.validation.state)
    
    // addidional description information field under the text field
    descriptionValueLabel.text = vm.visualisation.detailsText
    
    //
    // Configure buttons and components
    //
    cleareBtn.isHidden = true
    validateBtn.isHidden = !vm.validation.state.isVisibleValidationUI
    
    // Configurate next only one
    if !alreadyInitialized {
      configureRx()
      textField.delegate = self
      accessoryType = UITableViewCellAccessoryType.none
      
      alreadyInitialized = true
    }
  }
  
  // MARK: - UITextFieldDelegate
//  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
//                 replacementString string: String) -> Bool {
//    return textField.filtred(self.storedModel.information.keyboardOptions,
//                             string: string,
//                             range: range,
//                             maxLeng: self.storedModel.validation.maxLength)
//  }
  
  // MARK: - Additional helpers
  func showValidationWarning(text: String) {
//    Popup.hide()
//    Popup.failure(body: text)
    print("Show failure message")
  }
  
  func highlightField() {
    UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
      self.errorHighlightView.alpha = 0.3
    }, completion: { _ in
      UIView.animate(withDuration: 0.4, animations: {
        self.errorHighlightView.alpha = 0
      })
    })
  }
}

extension FormTextViewCell {
  func configureRx() {
  
    // Check validation all of text stream
    let validationState =
      textField.rx.text.asDriver().skip(1)
        .filter({[weak self] text -> Bool in
            return (text != self?.storedModel.value.transformForDisplay())
        })
        .map({[weak self] text in
          return self?.storedModel.validate(value: StringValue(value: text))
        }).startWith(self.storedModel.validation.state)
    
    // Hide warning ico while typing
    textField.rx.controlEvent(.editingDidBegin).asDriver().drive(onNext: {[weak self] _ in
      self?.validateBtn.isHidden = true
    }).disposed(by: bag)
    
    // Show validation only on end editing
    let endEditing = textField.rx.controlEvent(.editingDidEnd).asDriver()
      .withLatestFrom(validationState)
    
    // Show cleare button on start editting textfield
    textField.rx.controlEvent(.editingDidBegin).asDriver().drive(onNext: {[weak self] _ in
      self?.cleareBtn.isHidden = false
    }).disposed(by: bag)
    
    validationState.scan(RowSettings.ValidationState.valid) { [weak self] (_, newState) -> RowSettings.ValidationState? in
      guard let new = newState else {
        return .valid
      }
      
      self?.textField.validate(new)
      
      return new
    }.drive()
     .disposed(by: bag)
    
    // validate value on end editing text field
    endEditing.drive(onNext: {[weak self] valid in
      guard let v = valid else { return }
      
      self?.validateBtn.isHidden = v.isValidWithTyping
      self?.cleareBtn.isHidden = true
      if !v.isValidWithTyping {
//        self?.highlightField()
      }
    }).disposed(by: bag)
    
    // Clear text
    cleareBtn.rx.tap.subscribe(onNext: {[weak self] _ in
      self?.textField.text = ""
      self?.textField.sendActions(for: UIControlEvents.valueChanged)
    }).disposed(by: bag)
    
    // Show warning on tap
    validateBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
      if self.storedModel.validation.state.message != "" {
        self.showValidationWarning(text: self.storedModel.validation.state.message)
        self.highlightField()
      }
    }).disposed(by: bag)
  }
}
