//
//  RowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol RowItemVisibleBuilderProtocol {
  func defineVisible(interpreter: InterpreterConditions, visible: String, mandatory: String, disable: String)
}
  
protocol RowItemBaseBuilderProtocol {
  func defineBase(cellType: FBUniversalCellProtocol, identifier: String, level: ALFB.FormModelLevel, dataType: ALFB.DataType)
  func result() -> FromItemCompositeProtocol
}

protocol RowItemValidationBuilderProtocol {
  func defineValidation(validationType: ALFB.ValidationType, state: ALFB.ValidationState, valueKeyPath: String?, errorText: String?, maxLength: Int?)
}

protocol RowItemValueBuilderProtocol {
  func define(value: ALValueTransformable)
}

class RowItemBuilder: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol, RowItemValidationBuilderProtocol, RowItemValueBuilderProtocol {
  var visibleSetting = ALFB.Visible(interpreter: InterpreterConditions())
  var validation = ALFB.Validation(validationType: .none, state: .valid, valueKeyPath: nil, errorText: nil, maxLength: nil)
  var value: ALValueTransformable = StringValue(value: nil)
  var identifier: String = ""
  var level = ALFB.FormModelLevel.item
  var base = ALFB.Base(cellType: ALFBCells.editField, dataType: .string)
  
  func defineVisible(interpreter: InterpreterConditions, visible: String, mandatory: String, disable: String) {
    visibleSetting = ALFB.Visible(interpreter: interpreter, visible: visible, mandatory: mandatory, disable: disable)
  }
  
  func defineBase(cellType: FBUniversalCellProtocol, identifier: String, level: ALFB.FormModelLevel, dataType: ALFB.DataType) {
    base = ALFB.Base(cellType: cellType, dataType: dataType)
    self.identifier = identifier
    self.level = level
  }
  
  func defineValidation(validationType: ALFB.ValidationType, state: ALFB.ValidationState, valueKeyPath: String?, errorText: String?, maxLength: Int?) {
    validation = ALFB.Validation(validationType: validationType, state: state, valueKeyPath: valueKeyPath, errorText: errorText, maxLength: maxLength)
  }
  
  func define(value: ALValueTransformable) {
    self.value = value
  }
  
  func result() -> FromItemCompositeProtocol {
    return BaseFormComposite(identifier: "uncnown", level: .root)
  }
}
