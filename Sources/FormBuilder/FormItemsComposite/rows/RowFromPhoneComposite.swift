//
//  RowFromPhoneComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

// Протокол с которым работает ячейка
public protocol RowFromPhoneCompositeOutput: RowCompositeVisibleSetting, RowCompositeValidationSetting {
  var visualisation: ALFB.Visualization {get}
}

public class RowFromPhoneComposite: FromItemCompositeProtocol, RowFromPhoneCompositeOutput {
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
  
  public var didChangeData: DidChange?
  
  // MARK :- RowFormComposite properties
  public var value: ALValueTransformable
  public var validation: ALFB.Validation
  public var visualisation: ALFB.Visualization
  public var visible: ALFB.Visible
  public var base: ALFB.Base
  
  public init(composite: FromItemCompositeProtocol, value: ALValueTransformable, validation: ALFB.Validation,
       visualisation: ALFB.Visualization, visible: ALFB.Visible, base: ALFB.Base)
  {
    self.decoratedComposite = composite
    self.value = value
    self.validation = validation
    self.visualisation = visualisation
    self.visible = visible
    self.base = base
    
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
    case .phone:
      start.link(with: PhoneMiddlewareValidation())
      result = start.check(value: value.transformForDisplay())    
    default:
      let message = validation.errorText ?? ""
      return .failed(message: message)
    }
    
    switch result {
    case .valid:
      return .valid
      
    case .error(let message):
      let message = validation.errorText ?? message
      return .failed(message: message)
    }
  }
  
  // MARK :- FromItemCompositeProtocol func
  
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
