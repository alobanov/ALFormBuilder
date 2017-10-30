//
//  FormModelValidator.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol MiddlewareValidationProtocol {
  func check(value: String?) -> ALFB.ValidationResult
}

class MiddlewareValidation: MiddlewareValidationProtocol {
  var next: MiddlewareValidation?
  let errorText = "Next chain was not defined"
  
  @discardableResult func link(with: MiddlewareValidation) -> MiddlewareValidation {
    self.next = with
    return with
  }
  
  func check(value: String?) -> ALFB.ValidationResult {
    return checkNext(value: value)
  }
  
  func checkNext(value: String?) -> ALFB.ValidationResult {
    guard let next = self.next else {
      return .valid
    }
    
    return next.check(value: value)
  }
}
