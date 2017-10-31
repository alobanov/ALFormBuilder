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

class RowFormTextMultilineComposite: FromItemCompositeProtocol, RowFormTextCompositeOutput {
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
  
  var didChangeData: DidChange?
  
  // MARK :- RowFormComposite properties
  var value: ALValueTransformable
  var validation: ALFB.Validation
  var visualisation: ALFB.Visualization
  var visible: ALFB.Visible
  var base: ALFB.Base
  
  init(composite: FromItemCompositeProtocol, value: ALValueTransformable, validation: ALFB.Validation,
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
  
  func makeValidation(value: ALValueTransformable) -> ALFB.ValidationState {
    var result: ALFB.ValidationResult
    result = .valid
    
    switch result {
    case .valid:
      return .valid
      
    case .error(let message):
      let message = validation.errorText ?? message
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
