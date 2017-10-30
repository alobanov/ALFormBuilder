//
//  RowSettings.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit.UITableViewCell

public struct ALFB {
  enum ValidationResult {
    case error(String)
    case valid
  }
  
  struct Base {
    let cellType: FBUniversalCellProtocol
    var isStrictReload: Bool = false
    let dataType: DataType
    
    init(cellType: FBUniversalCellProtocol, dataType: DataType) {
      self.cellType = cellType
      self.dataType = dataType
    }
    
    mutating func needReloadModel() {
      self.isStrictReload = true
    }
    
    mutating func strictReload() -> Bool {
      var needReload = false
      if self.isStrictReload != needReload {
        self.isStrictReload = false
        needReload = true
      }
      
      return needReload
    }
  }
  
  struct Visualization {
    let placeholderText: String
    let placeholderTopText: String?
    let detailsText: String?
    let isPassword: Bool?
    let keyboardType: FBKeyboardType?
    let autocapitalizationType: FBAutocapitalizationType?
    let keyboardOptions: TextConstraintType
  }
  
  struct Validation {
    let validationType: ValidationType
    var state: ValidationState
    var valueKeyPath: String?
    let errorText: String?
    let maxLength: Int?
    
    mutating func change(state: ValidationState) {
      self.state = state
    }
  }
  
  struct Visible {
    static let fullValidation = "Full-Validation"
    
    let interpreter: InterpreterConditions
    
    let visibleExp: String
    let mandatoryExp: String
    let disabledExp: String
    
    var isVisible: Bool = true
    var isMandatory: Bool = true
    var isDisabled: Bool = false
    
    init(interpreter: InterpreterConditions, visible: String = "true", mandatory: String = "true", disable: String = "false") {
      self.interpreter = interpreter
      visibleExp = visible
      mandatoryExp = mandatory
      disabledExp = disable
    }
    
    mutating func checkDisableState(model: [String: Any]) -> Bool {
      if disabledExp == Visible.fullValidation {
        return false
      }
      
      let newState = interpreter.calculateExpression(expression: disabledExp, json: model)
      let isChanged = (newState != isDisabled)
      isDisabled = newState
      return isChanged
    }
    
    mutating func checkMandatoryState(model: [String: Any]) -> Bool {
      let newState = interpreter.calculateExpression(expression: mandatoryExp, json: model)
      let realMandatory = (newState && isVisible)
      let isChanged = (realMandatory != isMandatory)
      isMandatory = realMandatory
      return isChanged
    }
    
    mutating func checkVisibleState(model: [String: Any]) -> Bool {
      let newState = interpreter.calculateExpression(expression: visibleExp, json: model)
      let isChanged = (newState != isVisible)
      isVisible = newState
      return isChanged
    }
    
    mutating func changeDisabled(state: Bool) {
      self.isDisabled = state
    }
  }
  
  enum TextConstraintType: Int {
    case none = 0,
    removeWhitespaces = 1,
    onlyNumbers = 2,
    onlyDecimals = 3,
    phoneNumber = 4,
    cellularPhoneNumber = 5
    
    var options: UITextFieldFilterOptions {
      switch self {
      case .none:
        return [.None]
      case .onlyDecimals:
        return [.OnlyDecimalOption, .RemoveWhitespacesOption]
      case .onlyNumbers:
        return [.OnlyNumbersOption, .RemoveWhitespacesOption]
      case .removeWhitespaces:
        return [.RemoveWhitespacesOption]
      case .phoneNumber:
        return [.PhoneNumberOption]
      case .cellularPhoneNumber:
        return [.CellularPhoneNumberOption]
      }
    }
  }
}

protocol FBUniversalCellProtocol {
  var type: UITableViewCell.Type { get }
}
