//
//  ClosureMiddlewareValidation.swift
//  FormBuilder
//
//  Created by NVV on 19/12/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public struct ALFBClosureValidation {
  let closure: (String?) -> Bool
  let error: String
}

class ClosureMiddlewareValidation: MiddlewareValidation {
  
  private let model: ALFBClosureValidation// (error: String) -> Bool
  
  init(model: ALFBClosureValidation) {
    self.model = model
  }
  
  override func check(value: String?) -> ALFB.ValidationResult {
    let isValid = model.closure(value)
    if !isValid {
      return .error(model.error)
    }
    return self.checkNext(value: value)
  }
}
