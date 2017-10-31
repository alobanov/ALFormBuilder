//
//  RowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol RowItemVisibleBuilderProtocol {
  func defineVisible(interpreter: ALInterpreterConditions, visible: String, mandatory: String, disable: String)
}
  
public protocol RowItemBaseBuilderProtocol {
  func defineBase(cellType: FBUniversalCellProtocol, identifier: String, level: ALFB.FormModelLevel, dataType: ALFB.DataType)
  func result() -> FromItemCompositeProtocol
}

public protocol RowItemValidationBuilderProtocol {
  func defineValidation(validationType: ALFB.ValidationType, state: ALFB.ValidationState, valueKeyPath: String?, errorText: String?, maxLength: Int?)
}

public protocol RowItemValueBuilderProtocol {
  func define(value: ALValueTransformable)
}

public class RowItemBuilder: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol, RowItemValidationBuilderProtocol, RowItemValueBuilderProtocol {
  var visibleSetting = ALFB.Visible(interpreter: ALInterpreterConditions())
  var validation = ALFB.Validation(validationType: .none, state: .valid, valueKeyPath: nil, errorText: nil, maxLength: nil)
  var value: ALValueTransformable = ALStringValue(value: nil)
  var identifier: String = ""
  var level = ALFB.FormModelLevel.item
  var base = ALFB.Base(cellType: ALFB.Cells.emptyField, dataType: .string)
  
  public func defineVisible(interpreter: ALInterpreterConditions, visible: String, mandatory: String, disable: String) {
    visibleSetting = ALFB.Visible(interpreter: interpreter, visible: visible, mandatory: mandatory, disable: disable)
  }
  
  public func defineBase(cellType: FBUniversalCellProtocol, identifier: String, level: ALFB.FormModelLevel, dataType: ALFB.DataType) {
    base = ALFB.Base(cellType: cellType, dataType: dataType)
    self.identifier = identifier
    self.level = level
  }
  
  public func defineValidation(validationType: ALFB.ValidationType, state: ALFB.ValidationState, valueKeyPath: String?, errorText: String?, maxLength: Int?) {
    validation = ALFB.Validation(validationType: validationType, state: state, valueKeyPath: valueKeyPath, errorText: errorText, maxLength: maxLength)
  }
  
  public func define(value: ALValueTransformable) {
    self.value = value
  }
  
  public func result() -> FromItemCompositeProtocol {
    return BaseFormComposite(identifier: "uncnown", level: .root)
  }
}
