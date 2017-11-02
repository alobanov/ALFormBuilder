//
//  FormPhoneViewCellTableViewCell.swift
//  Puls
//
//  Created by MOPC on 24/07/2017.
//  Copyright © 2017 MOPC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class ALFBPhoneViewCell: UITableViewCell, RxCellReloadeble, UITextFieldDelegate {

  enum PhonePart: Int {
    case baseCode = 0, cityCode = 1, phone = 2
    
    var index: Int {
      return self.rawValue
    }
    
    var count: Int {
      switch self {
      case .baseCode: return 1
      case .cityCode: return 2
      case .phone: return 3
      }
    }
  }
  
  let bag = DisposeBag()
  
  @IBOutlet weak var baseCodeLabel: UILabel!
  @IBOutlet weak var cityCodeField: UITextField!
  @IBOutlet weak var phoneField: UITextField!

  @IBOutlet weak var topPlaceholderLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var validateBtn: UIButton!
  @IBOutlet weak var cleareBtn: UIButton!
  
  @IBOutlet weak var errorHighlightView: UIView!
  
  private var storedModel: RowFromPhoneCompositeOutput!
  private var alreadyInitialized = false
  
  fileprivate var validationState: BehaviorSubject<ALFB.ValidationState>!
  fileprivate var didChangeValidation: DidChangeValidation!
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // base configuration
    validateBtn.setImage(ALFBStyle.imageOfTfAlertIconStar, for: UIControlState())
    cleareBtn.setImage(ALFBStyle.imageOfCloseBtn(customColor: ALFBStyle.fbGray), for: UIControlState())
    
    validateBtn.isHidden = true
    cleareBtn.isHidden = true
    clipsToBounds = true
    
    errorHighlightView.alpha = 0
    errorHighlightView.isUserInteractionEnabled = false
    
    cityCodeField.tag = PhonePart.cityCode.rawValue
    phoneField.tag = PhonePart.phone.rawValue
    
    self.didChangeValidation = { [weak self] _ in
      if let state = self?.storedModel.validation.state {
        self?.validationState.onNext(state)
      }
    }
    
    self.layoutIfNeeded()
  }
  
  public func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let vm = model as? RowFromPhoneCompositeOutput else {
      return
    }
    
    storedModel = vm
    
    // Configurate text field
    // keybord type
    cityCodeField.keyboardType = vm.visualisation.keyboardType?.value ?? .default
    phoneField.keyboardType = vm.visualisation.keyboardType?.value ?? .default
    
    // Additional placeholder above the input text
    topPlaceholderLabel.text = vm.visualisation.placeholderText
    cityCodeField.placeholder = "Код"
    phoneField.placeholder = "Номер"
    
    // Can editable
    cityCodeField.isUserInteractionEnabled = !vm.visible.isDisabled
    cityCodeField.textColor = cityCodeField.isUserInteractionEnabled
      ? UIColor.black
      : UIColor.lightGray
    
    self.backgroundColor = cityCodeField.isUserInteractionEnabled
      ? UIColor.white
      : UIColor.lightGray
    
    let value = vm.value.transformForDisplay() ?? ""
    
    // Set value
    baseCodeLabel.text = "+\(phonePartFrom(text: value, byType: .baseCode))"
    cityCodeField.text = phonePartFrom(text: value, byType: .cityCode)
    phoneField.text = phonePartFrom(text: value, byType: .phone)
    
    topPlaceholderLabel.textColor = self.storedModel.validation.state.color
    
    // addidional description information field under the text field
    descriptionLabel.text = vm.visualisation.detailsText
    
    //
    // Configure buttons and components
    //
    cleareBtn.isHidden = true
    validateBtn.isHidden = !vm.validation.state.isVisibleValidationUI
    if !validateBtn.isHidden {
      validateBtn.isHidden = !vm.visible.isMandatory
    }
    
    if let s = self.storedModel as? FromItemCompositeProtocol {
      self.storedModel.didChangeValidation[s.identifier] = didChangeValidation
    }
    
    // Configurate next only one
    if !alreadyInitialized {
      self.configureRx()
      
      cityCodeField.delegate = self
      phoneField.delegate = self
      
      accessoryType = UITableViewCellAccessoryType.none
      
      alreadyInitialized = true
    }
  }
  
  private func phonePartFrom(text: String, byType: PhonePart) -> String {
    let phoneNumberParts = text.components(separatedBy: " ")
    return (phoneNumberParts.count>=byType.count) ? phoneNumberParts[byType.index] : ""
  }
  
  private func phoneParts() -> [String] {
    let value = self.storedModel.value.transformForDisplay() ?? ""
    
    return [phonePartFrom(text: value, byType: .baseCode),
            phonePartFrom(text: value, byType: .cityCode),
            phonePartFrom(text: value, byType: .phone)]
  }
  
  private func storePhonePart(text: String, byType: PhonePart) {
    var phoneArr = phoneParts()
    phoneArr[byType.rawValue] = text
    let value = phoneArr.joined(separator: " ")
    storedModel.update(value: ALStringValue(value: value))
  }
  
  // MARK: - UITextFieldDelegate
  public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
    let maxLength = (textField.tag == 1) ? 5 : 9

    return textField.filtred(self.storedModel.visualisation.keyboardOptions.options,
                             string: string,
                             range: range,
                             maxLeng: maxLength)
  }
  
  // MARK: - Additional helpers
  open func showValidationWarning(text: String) {
    // need override
  }
  
  private func highlightField() {
    UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
      self.errorHighlightView.alpha = 0.3
    }, completion: { _ in
      UIView.animate(withDuration: 0.4, animations: {
        self.errorHighlightView.alpha = 0
      })
    })
  }
  
  func configureRx() {
    self.validationState = BehaviorSubject<ALFB.ValidationState>(value: self.storedModel.validation.state)
    
    // События начала ввода
    let startEditingCity = cityCodeField.rx.controlEvent(.editingDidBegin).asDriver()
    let startEditingPhone = phoneField.rx.controlEvent(.editingDidBegin).asDriver()
    
    // Сосотояние валидации полей при вводе
//    let validationCityCode =
    cityCodeField.rx.text.asDriver().skip(1)
      .filter { [weak self] text -> Bool in
        let value = self?.storedModel.value.transformForDisplay() ?? ""
        return (text != self?.phonePartFrom(text: value, byType: .cityCode))
      }
      .drive(onNext: { [weak self] text in
        return self?.storePhonePart(text: text ?? "", byType: .cityCode)
      }).disposed(by: bag)
    //.startWith(storedModel.validation.state)
    
    //let validationPhone =
    phoneField.rx.text.asDriver().skip(1)
      .filter { [weak self] text -> Bool in
        let value = self?.storedModel.value.transformForDisplay() ?? ""
        return (text != self?.phonePartFrom(text: value,
                                            byType: .phone))
      }
      .drive(onNext: { [weak self] text in
        self?.storePhonePart(text: text ?? "", byType: .phone)
      }).disposed(by: bag)
    //.startWith(storedModel.validation.state)
    
    // События конца ввода
    let endEditingCity = cityCodeField.rx.controlEvent(.editingDidEnd).asObservable()
      .withLatestFrom(validationState)
    
    let endEditingPhone = phoneField.rx.controlEvent(.editingDidEnd).asObservable()
      .withLatestFrom(validationState)
    
    // При активном фокусе полей показываем кнопку "отчистить"
    Driver.merge([startEditingCity, startEditingPhone])
      .do(onNext: { [weak self] _ in
        self?.storedModel.base.changeisEditingNow(true)
        self?.cleareBtn.isHidden = false
        self?.validateBtn.isHidden = true
      })
      .drive()
      .disposed(by: bag)
    
    // Проверяем последнее значение валидации и подсвечиваем верхний залоголов
    validationState
      .scan(ALFB.ValidationState.valid) { [weak self] (_, newState) -> ALFB.ValidationState? in
        self?.topPlaceholderLabel.textColor = newState.color
        return newState
      }.subscribe()
      .disposed(by: bag)
    
    // После потери фокуса показываем состояние валидации
    Observable.merge([endEditingCity, endEditingPhone]).subscribe(onNext: { [weak self] valid in
      self?.storedModel.base.changeisEditingNow(false)
      self?.validateBtn.isHidden = valid.isValidWithTyping
      self?.cleareBtn.isHidden = true
      let isMandatory = self?.storedModel.visible.isMandatory ?? false
      if !isMandatory {
        self?.validateBtn.isHidden = !isMandatory
      }
      
      if !valid.isValidWithTyping {
        if valid.message != "" {
          self?.showValidationWarning(text: valid.message)
        }
      }
    }).disposed(by: bag)
    
    // Отчистка полей
    cleareBtn.rx.tap.subscribe(onNext: {[weak self] _ in
      self?.cityCodeField.text = ""
      self?.phoneField.text = ""
      
      // Посылаем событие о том что мы поменяли текс программно
      self?.cityCodeField.sendActions(for: UIControlEvents.valueChanged)
      self?.phoneField.sendActions(for: UIControlEvents.valueChanged)
    }).disposed(by: bag)
    
    // При нажатии на звездочку показываем ссощение об ошибке
    validateBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
      if self.storedModel.validation.state.message != "" {
        self.showValidationWarning(text: self.storedModel.validation.state.message)
        self.highlightField()
      }
    }).disposed(by: bag)
  }
}
