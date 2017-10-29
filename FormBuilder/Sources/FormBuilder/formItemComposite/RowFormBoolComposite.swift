//
//  RowComposite.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol RowFormBoolCompositeOutput:
  RowCompositeValueTransformable, RowCompositeVisibleSetting, RowCompositeVisualizationSetting, RowCompositeValidationSetting
{}

class RowFormBoolComposite: FromItemCompositeProtocol, RowFormBoolCompositeOutput {  
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
  
  // MARK :- RowFormComposite properties
  var visible: RowSettings.Visible
  var base: RowSettings.Base
  var visualisation: RowSettings.Visualization
  var value: ValueTransformable
  var validation: RowSettings.Validation
  var didChangeData: DidChange?
  
  init(composite: FromItemCompositeProtocol, value: ValueTransformable, visible: RowSettings.Visible,
       base: RowSettings.Base, visualisation: RowSettings.Visualization, validation: RowSettings.Validation)
  {
    self.decoratedComposite = composite
    self.visible = visible
    self.visualisation = visualisation
    self.value = value
    self.validation = validation
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
      
    default:
      return .failed(message: "error")
    }
    
    switch result {
    case .valid:
      return .valid
      
    case .error(let error):
      let message = visualisation.errorText ?? error.localizedDescription
      return .failed(message: message)
    }
  }
  
  func isValid() -> Bool {
    return self.validation.state.isCompletelyValid
  }
  
  func wasChanged() -> Bool {
    return self.value.wasModify
  }
}
