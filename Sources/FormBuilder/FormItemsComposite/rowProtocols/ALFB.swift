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
  public enum ValidationResult {
    case error(String)
    case valid
  }
  
  public struct Base {
    public let cellType: FBUniversalCellProtocol
    public var isStrictReload: Bool = false
    public let dataType: DataType
    public var isEditingNow: Bool = false
    
    public init(cellType: FBUniversalCellProtocol, dataType: DataType) {
      self.cellType = cellType
      self.dataType = dataType
    }
    
    public mutating func needReloadModel() {
      self.isStrictReload = true
    }
    
    public mutating func changeisEditingNow(_ state: Bool) {
      self.isEditingNow = state
    }
    
    public mutating func strictReload() -> Bool {
      var needReload = false
      if self.isStrictReload != needReload {
        self.isStrictReload = false
        if !isEditingNow {
          needReload = true
        }
      }
      
      return needReload
    }
  }
  
  public struct Visualization {
    public let placeholderText: String
    public let placeholderTopText: String?
    public let detailsText: String?
    public let isPassword: Bool?
    public let keyboardType: FBKeyboardType?
    public let autocapitalizationType: FBAutocapitalizationType?
    public let keyboardOptions: TextConstraintType
    
    public init(placeholderText: String, placeholderTopText: String?, detailsText: String?, isPassword: Bool?, keyboardType: FBKeyboardType?, autocapitalizationType: FBAutocapitalizationType?, keyboardOptions: TextConstraintType) {
      self.placeholderText = placeholderText
      self.placeholderTopText = placeholderTopText
      self.detailsText = detailsText
      self.isPassword = isPassword
      self.keyboardType = keyboardType
      self.autocapitalizationType = autocapitalizationType
      self.keyboardOptions = keyboardOptions
    }
  }
  
  public struct Validation {
    public let validationType: ValidationType
    public var state: ValidationState
    public var valueKeyPath: String?
    public let errorText: String?
    public let maxLength: Int?
    internal let doNotValidateUntilInteract: Bool
    
    public init(validationType: ValidationType, dNVU: Bool, valueKeyPath: String?, errorText: String?, maxLength: Int?) {
      self.validationType = validationType
      self.state = .typing
      self.valueKeyPath = valueKeyPath
      self.errorText = errorText
      self.maxLength = maxLength
      self.doNotValidateUntilInteract = dNVU
    }
    
    public mutating func change(state: ValidationState) {
      self.state = state
    }
  }
  
  public struct Visible {
    public static let fullValidation = "Full-Validation"
    
    public let interpreter: ALInterpreterConditions
    
    public let visibleExp: String
    public let mandatoryExp: String
    public let disabledExp: String
    public let validateExp: String?
    
    public var isVisible: Bool = true
    public var isMandatory: Bool = true
    public var isDisabled: Bool = false
    public var isValid: Bool = true
    
    public init(interpreter: ALInterpreterConditions, visible: String = "true",
                mandatory: String = "true", disable: String = "false", valid: String? = nil) {
      self.interpreter = interpreter
      visibleExp = visible
      mandatoryExp = mandatory
      disabledExp = disable
      validateExp = valid
    }
    
    public mutating func checkDisableState(model: [String: Any]) -> Bool {
      if disabledExp == Visible.fullValidation {
        return false
      }
      
      let newState = interpreter.calculateExpression(expression: disabledExp, json: model)
      let isChanged = (newState != isDisabled)
      isDisabled = newState
      return isChanged
    }
    
    public mutating func checkMandatoryState(model: [String: Any]) -> Bool {
      let newState = interpreter.calculateExpression(expression: mandatoryExp, json: model)
      let realMandatory = (newState && isVisible)
      let isChanged = (realMandatory != isMandatory)
      isMandatory = realMandatory
      return isChanged
    }
    
    public mutating func checkVisibleState(model: [String: Any]) -> Bool {
      let newState = interpreter.calculateExpression(expression: visibleExp, json: model)
      let isChanged = (newState != isVisible)
      isVisible = newState
      return isChanged
    }
    
    public mutating func checkValidState(model: [String: Any]) -> Bool {
      guard let expression = validateExp else {
        return false
      }
      
      let newState = interpreter.calculateExpression(expression: expression, json: model)
      let isChanged = (newState != isValid)
      isValid = newState
      return isChanged
    }
    
    public mutating func changeDisabled(state: Bool) {
      self.isDisabled = state
    }
  }
  
  public enum TextConstraintType: Int {
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

public protocol FBUniversalCellProtocol {
  var type: UITableViewCell.Type { get }
}
