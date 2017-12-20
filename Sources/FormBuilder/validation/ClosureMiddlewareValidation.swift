//
//  ClosureMiddlewareValidation.swift
//  FormBuilder
//
//  Created by NVV on 19/12/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public struct ALFBClosureValidation {
  public let closure: (String?) -> Bool
  public let error: String
  public init(closure: @escaping (String?) -> Bool, error: String) {
    self.closure = closure
    self.error = error
  }
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
