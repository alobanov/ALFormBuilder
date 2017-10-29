//
//  FormModelValidator.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

enum ValidationResult {
  case error(NSError)
  case valid
}

protocol MiddlewareValidationProtocol {
  func check(value: String?) -> ValidationResult
}

class MiddlewareValidation: MiddlewareValidationProtocol {
  var next: MiddlewareValidation?
  let error = NSError(domain: "ru.alobanov", code: 1, userInfo: [NSLocalizedDescriptionKey: "Next chain was not defined"])
  
  @discardableResult func link(with: MiddlewareValidation) -> MiddlewareValidation {
    self.next = with
    return with
  }
  
  func check(value: String?) -> ValidationResult {
    return checkNext(value: value)
  }
  
  func checkNext(value: String?) -> ValidationResult {
    guard let next = self.next else {
      return .valid
    }
    
    return next.check(value: value)
  }
}
