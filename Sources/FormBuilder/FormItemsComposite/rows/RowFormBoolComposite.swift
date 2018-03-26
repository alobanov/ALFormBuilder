//
//  RowComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol RowFormBoolCompositeOutput: FormItemCompositeProtocol, RowCompositeVisibleSetting, RowCompositeValidationSetting {
  var title: String {get}
}

public class RowFormBoolComposite: RowFormBoolCompositeOutput {
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
  
  public var customData: Any?
  
  // MARK :- RowFormComposite properties
  public var visible: ALFB.Condition
  public var base: ALFB.Base
  public var value: ALValueTransformable
  public var validation: ALFB.Validation
  public var didChangeData: DidChange?
  public var title: String
  
  init(composite: FormItemCompositeProtocol, value: ALValueTransformable, visible: ALFB.Condition,
       base: ALFB.Base, validation: ALFB.Validation, title: String)
  {
    self.decoratedComposite = composite
    self.visible = visible
    self.value = value
    self.validation = validation
    self.base = base
    self.title = title
    
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
    case .closure(let model):
      start.link(with: ClosureMiddlewareValidation(model: model))
      result = start.check(value: value.transformForDisplay())
    default:
      return .failed(message: validation.errorText ?? "Error text is not defined")
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
