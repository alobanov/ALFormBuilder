//
//  RowComposite.swift
//  ALFormBuilder
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
  var level: ALFB.FormModelLevel = .item
  
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
  var visible: ALFB.Visible
  var base: ALFB.Base
  var value: ALValueTransformable
  var validation: ALFB.Validation
  var didChangeData: DidChange?
  var title: String
  
  init(composite: FromItemCompositeProtocol, value: ALValueTransformable, visible: ALFB.Visible,
       base: ALFB.Base, validation: ALFB.Validation, title: String)
  {
    self.decoratedComposite = composite
    self.visible = visible
    self.value = value
    self.validation = validation
    self.base = base
    self.title = title
    
    validate(value: value)
  }
  
  func makeValidation(value: ALValueTransformable) -> ALFB.ValidationState {
    var result: ALFB.ValidationResult
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
      
    case .error(let message):
      let message = validation.errorText ?? message
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
