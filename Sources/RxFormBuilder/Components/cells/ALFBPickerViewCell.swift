//
//  FormPickerViewCell.swift
//  Puls
//
//  Created by Andrey Kuznetsov on 06.09.17.
//  Copyright © 2017 Aleksey Lobanov. All rights reserved.
//

import UIKit
import RxSwift

open class ALFBPickerViewCell: UITableViewCell, RxCellReloadeble {
  
  @IBOutlet weak var lblText: UILabel!
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
    lblText.isUserInteractionEnabled = false
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
   
    // Value
    let value = vm.value.transformForDisplay() ?? ""
    lblText.text = value.isEmpty ? vm.visualisation.placeholderText : value
    
    // addidional description information field under the text field
    descriptionValueLabel.text = vm.visualisation.detailsText
    
    // Fill by color for validation state
    lblText.textColor = vm.validation.state.color
    
    validationBorder.isHidden = !vm.validation.state.isVisibleValidationUI
    
    if let s = self.storedModel as? FormItemCompositeProtocol {
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
    validationState.subscribe(onNext: { [weak self] result in
      self?.lblText.textColor = result.color
      self?.validationBorder.isHidden = result.isCompletelyValid
    }).disposed(by: bag)
  }
}
