//
//  NilMiddlewareValidation.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class NilMiddlewareValidation: MiddlewareValidation {
  override func check(value: String?) -> ALFB.ValidationResult {
    if value == nil {
      return .error("Значение равно nil")
    }
    
    return self.checkNext(value: value)
  }
}
