//
//  FormTextViewCell.swift
//  Plus
//
//  Created by Aleksey Lobanov on 15.03.17.
//  Copyright © 2017 Aleksey Lobanov All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class ALFBTextViewCell: UITableViewCell, RxCellReloadeble, UITextFieldDelegate {
  
  @IBOutlet weak var textField: ALValidatedTextField!
  @IBOutlet weak var descriptionValueLabel: UILabel!
  @IBOutlet weak var validateBtn: UIButton!
  @IBOutlet weak var cleareBtn: UIButton!
  @IBOutlet weak var errorHighlightView: UIView!
  
  fileprivate var storedModel: RowFormTextCompositeOutput!
  fileprivate var alreadyInitialized = false
  
  fileprivate var validationState: BehaviorSubject<ALFB.ValidationState>!
  fileprivate var didChangeValidation: DidChangeValidation!
  
  let bag = DisposeBag()
   
  open override func awakeFromNib() {
    super.awakeFromNib()
    // base configuration
    validateBtn.setImage(ALFBStyle.imageOfTfAlertIconStar, for: UIControlState())
    cleareBtn.setImage(ALFBStyle.imageOfCloseBtn(customColor: ALFBStyle.fbGray), for: UIControlState())
    
    errorHighlightView.alpha = 0
    errorHighlightView.isUserInteractionEnabled = false
    
    validateBtn.isHidden = true
    cleareBtn.isHidden = true
    clipsToBounds = true
    
    self.didChangeValidation = { [weak self] in
      if let state = self?.storedModel.validation.state {
        self?.validationState.onNext(state)
      }
    }
    textField.accessibilityIdentifier = "rrrr"
    layoutIfNeeded()
  }
  
  public func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let vm = model as? RowFormTextCompositeOutput else {
      return
    }
    
    // check type of model data
    switch vm.base.dataType {
    case .string, .decimal, .integer, .password:
      self.storedModel = vm
    break
      default: return
    }
    
    // Configurate text field
    // keybord type
    textField.keyboardType = vm.visualisation.keyboardType?.value ?? .default
    
    // Additional placeholder above the input text
    textField.textPlaceholder = vm.visualisation.placeholderTopText
    textField.autocapitalizationType = vm.visualisation.autocapitalizationType?.value ?? .none
    
    // Just place holder
    textField.placeholder = vm.visualisation.placeholderText
    
    // Can editable
    textField.isUserInteractionEnabled = !vm.visible.isDisabled
    self.textField.textColor = textField.isUserInteractionEnabled
      ? ALFBStyle.fbDarkGray
      : ALFBStyle.fbLightGray
    
    self.backgroundColor = textField.isUserInteractionEnabled
      ? UIColor.white
      : ALFBStyle.fbUltraLightGray
    
    // is password type
    textField.isSecureTextEntry = vm.visualisation.isPassword ?? false
    
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
    if !validateBtn.isHidden {
      validateBtn.isHidden = !vm.visible.isMandatory
    }
    
    if let s = self.storedModel {
      self.storedModel.didChangeValidation[s.identifier] = didChangeValidation
    }
    
    // Configurate next only one
    if !alreadyInitialized {
      configureRx()
      textField.delegate = self
      accessoryType = UITableViewCellAccessoryType.none
      
      alreadyInitialized = true
    }
    
    textField.isAccessibilityElement = true
    textField.accessibilityIdentifier = vm.identifier
    textField.accessibilityLabel = textField.text
    validateBtn.accessibilityIdentifier = "validate_\(vm.identifier)"
    cleareBtn.accessibilityIdentifier = "clear_\(vm.identifier)"
  }
  
  // MARK: - UITextFieldDelegate
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    return textField.filtred(self.storedModel.visualisation.keyboardOptions.options,
                             string: string,
                             range: range,
                             maxLeng: self.storedModel.validation.maxLength,
                             maxFractionDigits: self.storedModel.visualisation.keyboardOptions.maxFractionDigits)
  }
  
  // MARK: - Additional helpers
  open func showValidationWarning(text: String) {
    // need override
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

extension ALFBTextViewCell {
  
  func change(value: String?) {
    var newValue: ALValueTransformable
    switch self.storedModel.base.dataType {
    case .decimal:
      let value = (value ?? "").replace(string: ",", replacement: ".")
      newValue = ALFloatValue(value: Float(value))
    case .integer:
      newValue = ALIntValue(value: Int(value ?? ""))
    default:
      newValue = ALStringValue(value: value)
    }
    
    self.storedModel.update(value: newValue)
  }
  
  func configureRx() {
    self.validationState = BehaviorSubject<ALFB.ValidationState>(value: self.storedModel.validation.state)
    
    // Check validation all of text stream
    textField.rx.text.asDriver().skip(1)
      .filter({ [weak self] text -> Bool in
          return (text != self?.storedModel.value.transformForDisplay())
      }).drive(onNext: { [weak self] text in
        self?.change(value: text)
      }).disposed(by: bag)
    
    // Show validation only on end editing
    let endEditing = textField.rx.controlEvent(.editingDidEnd).asObservable()
      .withLatestFrom(validationState)
    
    // Show cleare button on start editting textfield
    textField.rx.controlEvent(.editingDidBegin).asDriver().drive(onNext: {[weak self] _ in
      self?.storedModel.base.changeisEditingNow(true)
      self?.validateBtn.isHidden = true
      self?.cleareBtn.isHidden = false
    }).disposed(by: bag)
    
    validationState.scan(ALFB.ValidationState.typing) { (oldState, newState) -> ALFB.ValidationState? in
        guard let old = oldState else { return .valid }
        if old == newState { return old }
        return newState
      }.subscribe(onNext: { [weak self] state in
        
        
        self?.textField.validate(state ?? .valid)
      })
     .disposed(by: bag)
    
    // validate value on end editing text field
    endEditing.subscribe(onNext: {[weak self] valid in
//      guard let v = valid else { return }
      
      self?.storedModel.base.changeisEditingNow(false)
      self?.validateBtn.isHidden = valid.isValidWithTyping
      let isMandatory = self?.storedModel.visible.isMandatory ?? false
      if !isMandatory {
        self?.validateBtn.isHidden = !isMandatory
      }
      self?.cleareBtn.isHidden = true
      if !valid.isValidWithTyping {
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
