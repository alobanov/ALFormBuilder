//
//  RowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol RowItemVisibleBuilderProtocol {
  func defineVisible(interpreter: ALInterpreterConditions, visible: String, mandatory: String, disable: String, valid: String?)
}
  
public protocol RowItemBaseBuilderProtocol {
  func defineBase(cellType: FBUniversalCellProtocol, identifier: String, level: ALFB.FormModelLevel, dataType: ALFB.DataType)
  func result() -> FormItemCompositeProtocol
}

public protocol RowItemValidationBuilderProtocol {
  func defineValidation(validationType: ALFB.ValidationType, validateAtCreation: Bool, valueKeyPath: String?, errorText: String?, maxLength: Int?)
  func defineValidation(validationType: ALFB.ValidationType, valueKeyPath: String?, errorText: String?, maxLength: Int?)
}

public protocol RowItemValueBuilderProtocol {
  func define(value: ALValueTransformable)
  func define(customValue: Any?)
}

public class RowItemBuilder: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol, RowItemValidationBuilderProtocol, RowItemValueBuilderProtocol {
  var visibleSetting = ALFB.Condition(interpreter: ALInterpreterConditions())
  var validation = ALFB.Validation(validationType: .none, validateAtCreation: false, valueKeyPath: nil, errorText: nil, maxLength: nil)
  var value: ALValueTransformable = ALStringValue(value: nil)
  var identifier: String = ""
  var level = ALFB.FormModelLevel.item
  var base = ALFB.Base(cellType: ALFB.Cells.emptyField, dataType: .string)
  var customData: Any?
  
  public func defineVisible(interpreter: ALInterpreterConditions, visible: String, mandatory: String, disable: String, valid: String?) {
    visibleSetting = ALFB.Condition(interpreter: interpreter, visible: visible, mandatory: mandatory, disable: disable, valid: valid)
  }
  
  public func defineBase(cellType: FBUniversalCellProtocol, identifier: String, level: ALFB.FormModelLevel, dataType: ALFB.DataType) {
    base = ALFB.Base(cellType: cellType, dataType: dataType)
    self.identifier = identifier
    self.level = level
  }
  
  public func defineValidation(validationType: ALFB.ValidationType, valueKeyPath: String?, errorText: String?, maxLength: Int?) {
    validation = ALFB.Validation(validationType: validationType, validateAtCreation: true, valueKeyPath: valueKeyPath, errorText: errorText, maxLength: maxLength)
  }
  
  public func defineValidation(validationType: ALFB.ValidationType, validateAtCreation: Bool, valueKeyPath: String?, errorText: String?, maxLength: Int?) {
    validation = ALFB.Validation(validationType: validationType, validateAtCreation: validateAtCreation, valueKeyPath: valueKeyPath, errorText: errorText, maxLength: maxLength)
  }
  
  public func define(value: ALValueTransformable) {
    self.value = value
  }
  
  public func define(customValue: Any?) {
    self.customData = customValue
  }
  
  public func result() -> FormItemCompositeProtocol {
    return BaseFormComposite(identifier: "uncnown", level: .root)
  }
}
