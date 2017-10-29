//
//  NilMiddlewareValidation.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class NilMiddlewareValidation: MiddlewareValidation {
  override func check(value: String?) -> ValidationResult {
    if value == nil {
      let d = [NSLocalizedDescriptionKey: "Значение равно nil"]
      let e = NSError(domain: "ru.alobanov", code: 1, userInfo: d)
      return .error(e)
    }
    
    return self.checkNext(value: value)
  }
}
