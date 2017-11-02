//
//  FormPickerViewCell.swift
//  Puls
//
//  Created by Andrey Kuznetsov on 06.09.17.
//  Copyright © 2017 MOPC. All rights reserved.
//

import UIKit
import RxSwift

open class ALFBPickerViewCell: UITableViewCell, RxCellReloadeble {
  
  @IBOutlet weak var textField: ALValidatedTextField!
  @IBOutlet weak var descriptionValueLabel: UILabel!
  @IBOutlet weak var validateBtn: UIButton!
  @IBOutlet weak var validationBorder: UIView!
  
  fileprivate var validationState: BehaviorSubject<ALFB.ValidationState>!
  fileprivate var didChangeValidation: DidChangeValidation!
  
  let bag = DisposeBag()
  
  fileprivate var storedModel: RowFormTextCompositeOutput!
  var alreadyInitialized = false
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    textField.isUserInteractionEnabled = false
    validateBtn.isHidden = true
    validationBorder.isHidden = true
    
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
    
    switch vm.base.dataType {
    case .picker:
      self.storedModel = vm
      break
    default: return
    }
    
    // Configurate text field
    textField.keyboardType = vm.visualisation.keyboardType?.value ?? .default
    
    // Value
    textField.text = vm.value.transformForDisplay() ?? ""
    
    // Additional placeholder above the input text
    textField.textPlaceholder = vm.visualisation.placeholderTopText
    
    // Just placeholder
    textField.placeholder = vm.visualisation.placeholderText
    
    // addidional description information field under the text field
    descriptionValueLabel.text = vm.visualisation.detailsText
    
    // Fill by color for validation state
    textField.validate(vm.validation.state)
    
    validationBorder.isHidden = !vm.validation.state.isVisibleValidationUI
    
    if let s = self.storedModel as? FromItemCompositeProtocol {
      self.storedModel.didChangeValidation[s.identifier] = didChangeValidation
    }
    
    // Configurate Rx once!
    if !alreadyInitialized {
      self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
      alreadyInitialized = true
      configureRx()
    }
  }
  
  private func configureRx() {
    self.validationState = BehaviorSubject<ALFB.ValidationState>(value: self.storedModel.validation.state)
    
    // Check validation all of text stream
    textField.rx.text.asDriver().skip(1).drive(onNext: { [weak self] text in
      self?.storedModel.update(value: ALStringValue(value: text))
    }).disposed(by: bag)
    
    validationState.subscribe(onNext: { [weak self] result in
      self?.textField.validate(result)
      self?.validationBorder.isHidden = result.isCompletelyValid
    }).disposed(by: bag)
  }
}
