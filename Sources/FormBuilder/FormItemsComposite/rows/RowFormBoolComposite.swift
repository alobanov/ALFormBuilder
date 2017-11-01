//
//  RowComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol RowFormBoolCompositeOutput: RowCompositeVisibleSetting, RowCompositeValidationSetting {
  var title: String {get}
}

public class RowFormBoolComposite: FromItemCompositeProtocol, RowFormBoolCompositeOutput {
  // MARK :- ModelItemDatasoursable
  private let decoratedComposite: FromItemCompositeProtocol
  
  // MARK :- FromItemCompositeProtocol properties
  public var level: ALFB.FormModelLevel = .item
  
  public var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  public var leaves: [FromItemCompositeProtocol] {
    return [self]
  }
  
  public var children: [FromItemCompositeProtocol] {
    return []
  }
  
  public var datasource: [FromItemCompositeProtocol] {
    return self.visible.isVisible ? [self] : []
  }
  
  // MARK :- RowFormComposite properties
  public var visible: ALFB.Visible
  public var base: ALFB.Base
  public var value: ALValueTransformable
  public var validation: ALFB.Validation
  public var didChangeData: DidChange?
  public var title: String
  
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
  
  public func makeValidation(value: ALValueTransformable) -> ALFB.ValidationState {
    var result: ALFB.ValidationResult
    let start = PreparingMiddlewareValidation()
    
    switch validation.validationType {
    case .none:
      result = .valid
    case .nonNil:
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
