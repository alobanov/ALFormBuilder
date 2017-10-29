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
  func defineBase(cellType: UniversalCellProtocol, identifier: String, level: FormModelLevel)
  func result() -> FromItemCompositeProtocol
}

protocol RowItemValidationBuilderProtocol {
  func defineValidation(validationType: RowSettings.ValidationType, state: RowSettings.ValidationState, valueKeyPath: String?)
}

protocol RowItemVisualizationBuilderProtocol {
  func defineVisualization(placeholderText: String, placeholderTopText: String?, detailsText: String?, dataType: RowSettings.DataType, isPassword: Bool, errorText: String?, keyboardType: FBKeyboardType, autocapitalizationType: FBAutocapitalizationType)
}

protocol RowItemValueBuilderProtocol {
  func define(value: ValueTransformable)
}

class RowItemBuilder: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol, RowItemValidationBuilderProtocol, RowItemVisualizationBuilderProtocol, RowItemValueBuilderProtocol {
  var visibleSetting = RowSettings.Visible(interpreter: InterpreterConditions())
  var validation = RowSettings.Validation(validationType: .none, state: .valid, valueKeyPath: nil)
  var visualization = RowSettings.Visualization(placeholderText: "", placeholderTopText: nil, detailsText: nil, dataType: RowSettings.DataType.string, isPassword: false, errorText: nil, keyboardType: .defaultKeyboard, autocapitalizationType: .none)
  var value: ValueTransformable = StringValue(value: nil)
  var identifier: String = ""
  var level = FormModelLevel.item
  var base = RowSettings.Base(cellType: FormBuilderCells.editField)
  
  func defineVisible(interpreter: InterpreterConditions, visible: String, mandatory: String, disable: String) {
    visibleSetting = RowSettings.Visible(interpreter: interpreter, visible: visible, mandatory: mandatory, disable: disable)
  }
  
  func defineBase(cellType: UniversalCellProtocol, identifier: String, level: FormModelLevel) {
    base = RowSettings.Base(cellType: cellType)
    self.identifier = identifier
    self.level = level
  }
  
  func defineValidation(validationType: RowSettings.ValidationType, state: RowSettings.ValidationState, valueKeyPath: String?) {
    validation = RowSettings.Validation(validationType: validationType, state: state, valueKeyPath: valueKeyPath)
  }
  
  func defineVisualization(placeholderText: String, placeholderTopText: String?, detailsText: String?, dataType: RowSettings.DataType, isPassword: Bool, errorText: String?, keyboardType: FBKeyboardType, autocapitalizationType: FBAutocapitalizationType) {
    visualization = RowSettings.Visualization(placeholderText: placeholderText, placeholderTopText: placeholderTopText, detailsText: detailsText, dataType: dataType, isPassword: isPassword, errorText: errorText, keyboardType: keyboardType, autocapitalizationType: autocapitalizationType)
  }
  
  func define(value: ValueTransformable) {
    self.value = value
  }
  
  func result() -> FromItemCompositeProtocol {
    return BaseFormComposite(identifier: "uncnown", level: .root)
  }
}

/// String form item builder
protocol StringRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol,
RowItemValidationBuilderProtocol, RowItemVisualizationBuilderProtocol, RowItemValueBuilderProtocol {}

class StringRowItemBuilder: RowItemBuilder, StringRowItemBuilderProtocol {
  override func result() -> FromItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    return RowFormTextComposite(composite: baseComposite, value: self.value, validation: validation,
                            visualisation: visualization, visible: visibleSetting, base: base)
  }
}

/// Button form item builder
protocol ButtonRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol {}

class ButtonRowItemBuilder: RowItemBuilder, ButtonRowItemBuilderProtocol {
  private var title: String
  
  init(title: String) {
    self.title = title
  }
  
  override func result() -> FromItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    return RowFormButtonComposite(composite: baseComposite, visible: visibleSetting, base: base, title: self.title)
  }
}

/// Button form item builder
protocol BoolRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol,
RowItemValueBuilderProtocol, RowItemValidationBuilderProtocol, RowItemVisualizationBuilderProtocol {}

class BoolRowItemBuilder: RowItemBuilder, BoolRowItemBuilderProtocol {
  override func result() -> FromItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    return RowFormBoolComposite(composite: baseComposite, value: self.value, visible: visibleSetting, base: base, visualisation: visualization, validation: validation)
  }
}
