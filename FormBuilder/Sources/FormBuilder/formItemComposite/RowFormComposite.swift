//
//  Composite.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 26/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit.UITableViewCell

// Протокол с которым работает ячейка
protocol RowFormCompositeOutput:
  RowCompositeValueTransformable, RowCompositeVisibleSetting,
  RowCompositeValidationSetting, RowCompositeVisualizationSetting
{}

class RowFormComposite: FromItemCompositeProtocol, RowFormCompositeOutput {
  // MARK :- ModelItemDatasoursable
  private let decoratedComposite: FromItemCompositeProtocol
  
  // MARK :- FromItemCompositeProtocol properties  
  var level: FormModelLevel = .item
  
  var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  var leaves: [FromItemCompositeProtocol] {
    return [self]
  }
  
  var children: [FromItemCompositeProtocol] {
    return []
  }
  
  var datasource: [FromItemCompositeProtocol] {
    return self.visible.isVisible ? [self] : []
  }
  
  var didChangeData: DidChange?
  
  // MARK :- RowFormComposite properties
  var value: ValueTransformable
  var validation: RowSettings.Validation
  var visualisation: RowSettings.Visualization
  var visible: RowSettings.Visible
  var base: RowSettings.Base
  
  init(composite: FromItemCompositeProtocol, value: ValueTransformable, validation: RowSettings.Validation,
       visualisation: RowSettings.Visualization, visible: RowSettings.Visible, base: RowSettings.Base)
  {
    self.decoratedComposite = composite
    self.value = value
    self.validation = validation
    self.visualisation = visualisation
    self.visible = visible
    self.base = base
    
    validate(value: value)
  }
  
  @discardableResult func validate(value: ValueTransformable) -> RowSettings.ValidationState {
    let result = tryValid(value: value)
    self.validation.change(state: result)
    
    if self.value.transformForDisplay() != value.transformForDisplay() {
      self.value.change(originalValue: value.retriveOriginalValue())
      didChangeData?(self)
    }
    
    return result
  }
  
  private func tryValid(value: ValueTransformable) -> RowSettings.ValidationState {
    var result: ValidationResult
    let start = PreparingMiddlewareValidation()
    
    switch validation.validationType {
    case .none:
      start.link(with: NilMiddlewareValidation())
      result = start.check(value: value.transformForDisplay())
      
    case .regexp(let regexpstr):
      start.link(with: RegExpMiddlewareValidation(regexp: regexpstr))
      result = start.check(value: value.transformForDisplay())
    }
    
    switch result {
    case .valid:
      return .valid
      
    case .error(let error):
      let message = visualisation.errorText ?? error.localizedDescription
      return .failed(message: message)
    }
  }
  
  // MARK :- FromItemCompositeProtocol func
  
  func isValid() -> Bool {
    return self.validation.state.isCompletelyValid
  }
  
  func wasChanged() -> Bool {
    return self.value.wasModify
  }
}
