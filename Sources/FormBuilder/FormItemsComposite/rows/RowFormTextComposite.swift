//
//  Composite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 26/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

// Протокол с которым работает ячейка
public protocol RowFormTextCompositeOutput: RowCompositeVisibleSetting, RowCompositeValidationSetting {
  var visualisation: ALFB.Visualization {get set}
}

public class RowFormTextComposite: FormItemCompositeProtocol, RowFormTextCompositeOutput {
  public var didChangeValidation: [String : DidChangeValidation?] = [:]
  
  // MARK :- ModelItemDatasoursable
  private let decoratedComposite: FormItemCompositeProtocol
  
  // MARK :- FormItemCompositeProtocol properties  
  public var level: ALFB.FormModelLevel {
    return self.decoratedComposite.level
  }
  
  public var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  public var leaves: [FormItemCompositeProtocol] {
    return [self]
  }
  
  public var children: [FormItemCompositeProtocol] {
    return []
  }
  
  public var datasource: [FormItemCompositeProtocol] {
    return self.visible.isVisible ? [self] : []
  }
  
  public var didChangeData: DidChange?
  
  // MARK :- RowFormComposite properties
  public var value: ALValueTransformable
  public var validation: ALFB.Validation
  public var visualisation: ALFB.Visualization
  public var visible: ALFB.Condition
  public var base: ALFB.Base
  
  public init(composite: FormItemCompositeProtocol, value: ALValueTransformable, validation: ALFB.Validation,
       visualisation: ALFB.Visualization, visible: ALFB.Condition, base: ALFB.Base)
  {
    self.decoratedComposite = composite
    self.value = value
    self.validation = validation
    self.visualisation = visualisation
    self.visible = visible
    self.base = base
    
    if validation.validateAtCreation {
      update(value: value)
    }
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
      result = .error(validation.errorText ?? "")
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
  
  public func isValid() -> Bool {
    if !self.visible.isMandatory {
      return true
    }
    
    return self.validation.state.isCompletelyValid
  }
  
  public func wasChanged() -> Bool {
    return self.value.wasModify
  }
}
