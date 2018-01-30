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
    public var placeholderText: String
    public var placeholderTopText: String?
    public var detailsText: String?
    public var isPassword: Bool?
    public var keyboardType: FBKeyboardType?
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
    public var validationType: ValidationType
    public var state: ValidationState
    public var valueKeyPath: String?
    public var errorText: String?
    public var maxLength: Int?
    internal let validateAtCreation: Bool
    
    public init(validationType: ValidationType, validateAtCreation: Bool, valueKeyPath: String?, errorText: String?, maxLength: Int?) {
      self.validationType = validationType
      self.state = .typing
      self.valueKeyPath = valueKeyPath
      self.errorText = errorText
      self.maxLength = maxLength
      self.validateAtCreation = validateAtCreation
    }
    
    public mutating func change(state: ValidationState) {
      self.state = state
    }
  }
  
  public struct Condition {
    public static let fullValidation = "Full-Validation"
    public let interpreter: ALInterpreterConditions
    
    public var visibleExp: String
    public var mandatoryExp: String
    public var disabledExp: String
    public var validateExp: String?
    
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
      if disabledExp == Condition.fullValidation {
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
  
  public enum TextConstraintType {
    case none,
    removeWhitespaces,
    onlyNumbers,
    onlyDecimals(maxFractionDigits: Int),
    phoneNumber,
    cellularPhoneNumber
    
    public var maxFractionDigits: Int {
      switch self {
      case .onlyDecimals(let maxFractionDigits):
        return maxFractionDigits
      default:
        return 0
      }
    }
    
    public var options: UITextFieldFilterOptions {
      switch self {
      case .none:
        return [.None]
      case .onlyDecimals(_):
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
