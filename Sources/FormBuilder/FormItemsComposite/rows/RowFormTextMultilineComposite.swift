//
//  RowFormTextMultilineComposite.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

// Протокол с которым работает ячейка
protocol RowFormTextMultilineCompositeOutput: RowCompositeVisibleSetting, RowCompositeValidationSetting {
  var visualisation: ALFB.Visualization {get}
}

class RowFormTextMultilineComposite: FormItemCompositeProtocol, RowFormTextCompositeOutput {
  var didChangeValidation: [String : DidChangeValidation?] = [:]
  
  // MARK :- ModelItemDatasoursable
  private let decoratedComposite: FormItemCompositeProtocol
  
  // MARK :- FormItemCompositeProtocol properties
  var level: ALFB.FormModelLevel {
    return self.decoratedComposite.level
  }
  
  var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  var leaves: [FormItemCompositeProtocol] {
    return [self]
  }
  
  var children: [FormItemCompositeProtocol] {
    return []
  }
  
  var datasource: [FormItemCompositeProtocol] {
    return self.visible.isVisible ? [self] : []
  }
  
  var didChangeData: DidChange?
  
  // MARK :- RowFormComposite properties
  var value: ALValueTransformable
  var validation: ALFB.Validation
  var visualisation: ALFB.Visualization
  var visible: ALFB.Condition
  var base: ALFB.Base
  
  init(composite: FormItemCompositeProtocol, value: ALValueTransformable, validation: ALFB.Validation,
              visualisation: ALFB.Visualization, visible: ALFB.Condition, base: ALFB.Base)
  {
    self.decoratedComposite = composite
    self.value = value
    self.validation = validation
    self.visualisation = visualisation
    self.visible = visible
    self.base = base
    
    update(value: value)
  }
  
  public func validate(value: ALValueTransformable) -> ALFB.ValidationState {
    var result: ALFB.ValidationResult
    let start = PreparingMiddlewareValidation()
    
    switch validation.validationType {
    case .none:
      result = .valid
    case .nonNil:
      start.link(with: NilMiddlewareValidation())
      result = start.check(value: value.transformForDisplay())
    case .regexp(let regexpstr):
      start.link(with: RegExpMiddlewareValidation(regexp: regexpstr))
      result = start.check(value: value.transformForDisplay())
    default:
      result = .valid
    }
    
    if !self.visible.isValid {
      result = .error("Валидация по выражению не пройдена")
    }
    
    switch result {
    case .valid:
      return .valid
      
    case .error(let message):
      let message = validation.errorText ?? message
      return .failed(message: message)
    }
  }
  
  // MARK :- FormItemCompositeProtocol func
  
  func isValid() -> Bool {
    return self.validation.state.isCompletelyValid
  }
  
  func wasChanged() -> Bool {
    return self.value.wasModify
  }
}
