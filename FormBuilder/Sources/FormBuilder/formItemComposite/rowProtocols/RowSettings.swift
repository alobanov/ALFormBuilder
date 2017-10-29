//
//  RowSettings.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit.UITableViewCell

struct RowSettings {
  struct Base {
    let cellType: UniversalCellProtocol
    var isStrictReload: Bool = false
    let dataType: DataType
    
    init(cellType: UniversalCellProtocol, dataType: DataType) {
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
  }
  
  struct Restriction {
    let maxLength: Int?
  }
  
  struct Validation {
    let validationType: ValidationType
    var state: ValidationState
    var valueKeyPath: String?
    let errorText: String?
    
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
}

protocol UniversalCellProtocol {
  var type: UITableViewCell.Type { get }
}
