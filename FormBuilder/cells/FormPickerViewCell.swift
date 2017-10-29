//
//  FormPickerViewCell.swift
//  Puls
//
//  Created by Andrey Kuznetsov on 06.09.17.
//  Copyright © 2017 MOPC. All rights reserved.
//

import UIKit
import RxSwift

class FormPickerViewCell: UITableViewCell, RxCellReloadeble {
  
  @IBOutlet weak var textField: CCRegValidationTextField!
  @IBOutlet weak var descriptionValueLabel: UILabel!
  @IBOutlet weak var validateBtn: UIButton!
  @IBOutlet weak var validationBorder: UIView!
  
  let bag = DisposeBag()
  
  fileprivate var storedModel: RowFormTextCompositeOutput!
  var alreadyInitialized = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    textField.isUserInteractionEnabled = false
    validateBtn.isHidden = true
    validationBorder.isHidden = true
    self.layoutIfNeeded()
    
    descriptionValueLabel.textColor = UIColor.lightText
  }
  
  func reload(with model: RxCellModelDatasoursable) {
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
    
    // Configurate Rx once!
    if !alreadyInitialized {
      self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
      alreadyInitialized = true
      configureRx()
    }
  }
  
  func configureRx() {
    
    // Check validation all of text stream
    let validationState = textField.rx.text.asDriver().skip(1)
      .map({[weak self] text in
        return self?.storedModel.validate(value: StringValue(value: text))
      }).startWith(self.storedModel.validation.state)
    
    validationState.drive(onNext: {[weak self] result in
      if let v = result {
        self?.textField.validate(v)
        self?.validationBorder.isHidden = v.isCompletelyValid
      }
    }).disposed(by: bag)
  }
}
