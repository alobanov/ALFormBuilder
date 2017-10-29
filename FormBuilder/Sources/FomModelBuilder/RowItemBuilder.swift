//
//  RowItemBuilder.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol RowItemVisibleBuilderProtocol {
  func defineVisible(interpreter: InterpreterConditions, visible: String, mandatory: String, disable: String)
}
  
protocol RowItemBaseBuilderProtocol {
  func defineBase(cellType: UniversalCellProtocol, identifier: String, level: FormModelLevel, dataType: RowSettings.DataType)
  func result() -> FromItemCompositeProtocol
}

protocol RowItemValidationBuilderProtocol {
  func defineValidation(validationType: RowSettings.ValidationType, state: RowSettings.ValidationState, valueKeyPath: String?, errorText: String?)
}

protocol RowItemValueBuilderProtocol {
  func define(value: ValueTransformable)
}

class RowItemBuilder: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol, RowItemValidationBuilderProtocol, RowItemValueBuilderProtocol {
  var visibleSetting = RowSettings.Visible(interpreter: InterpreterConditions())
  var validation = RowSettings.Validation(validationType: .none, state: .valid, valueKeyPath: nil, errorText: nil)
  var value: ValueTransformable = StringValue(value: nil)
  var identifier: String = ""
  var level = FormModelLevel.item
  var base = RowSettings.Base(cellType: FormBuilderCells.editField, dataType: .string)
  
  func defineVisible(interpreter: InterpreterConditions, visible: String, mandatory: String, disable: String) {
    visibleSetting = RowSettings.Visible(interpreter: interpreter, visible: visible, mandatory: mandatory, disable: disable)
  }
  
  func defineBase(cellType: UniversalCellProtocol, identifier: String, level: FormModelLevel, dataType: RowSettings.DataType) {
    base = RowSettings.Base(cellType: cellType, dataType: dataType)
    self.identifier = identifier
    self.level = level
  }
  
  func defineValidation(validationType: RowSettings.ValidationType, state: RowSettings.ValidationState, valueKeyPath: String?, errorText: String?) {
    validation = RowSettings.Validation(validationType: validationType, state: state, valueKeyPath: valueKeyPath, errorText: errorText)
  }
  
  func define(value: ValueTransformable) {
    self.value = value
  }
  
  func result() -> FromItemCompositeProtocol {
    return BaseFormComposite(identifier: "uncnown", level: .root)
  }
}
