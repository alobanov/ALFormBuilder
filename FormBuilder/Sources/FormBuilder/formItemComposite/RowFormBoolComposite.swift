//
//  RowComposite.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol RowFormBoolCompositeOutput: RowCompositeVisibleSetting, RowCompositeValidationSetting {
  var title: String {get}
}

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
  var value: ValueTransformable
  var validation: RowSettings.Validation
  var didChangeData: DidChange?
  var title: String
  
  init(composite: FromItemCompositeProtocol, value: ValueTransformable, visible: RowSettings.Visible,
       base: RowSettings.Base, validation: RowSettings.Validation, title: String)
  {
    self.decoratedComposite = composite
    self.visible = visible
    self.value = value
    self.validation = validation
    self.base = base
    self.title = title
    
    validate(value: value)
  }
  
  func makeValidation(value: ValueTransformable) -> RowSettings.ValidationState {
    var result: ValidationResult
    let start = PreparingMiddlewareValidation()
    
    switch validation.validationType {
    case .none:
      start.link(with: NilMiddlewareValidation())
      result = start.check(value: value.transformForDisplay())
      
    default:
      return .failed(message: validation.errorText ?? "Error text is not defined")
    }
    
    switch result {
    case .valid:
      return .valid
      
    case .error(let error):
      let message = validation.errorText ?? error.localizedDescription
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
