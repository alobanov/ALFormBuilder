//
//  RowFromPhoneComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

// Протокол с которым работает ячейка
public protocol RowFromPhoneCompositeOutput: FormItemCompositeProtocol, RowCompositeVisibleSetting, RowCompositeValidationSetting {
  var visualisation: ALFB.Visualization {get}
}

public class RowFromPhoneComposite: RowFromPhoneCompositeOutput {
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
  
  public var customData: Any? {
    return self.decoratedComposite.customData
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
    case .phone:
      start.link(with: PhoneMiddlewareValidation())
      result = start.check(value: value.transformForDisplay())
    case .closure(let model):
      start.link(with: ClosureMiddlewareValidation(model: model))
      result = start.check(value: value.transformForDisplay())
    default:
      let message = validation.errorText ?? ""
      return .failed(message: message)
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
