//
//  RegExpMiddlewareValidation.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class RegExpMiddlewareValidation: MiddlewareValidation {
  private let regexp: String?
  
  init(regexp: String?) {
    self.regexp = regexp
  }
  
  override func check(value: String?) -> ALFB.ValidationResult {
    guard let validatedValue = value else {
      return .error("Значение пустое")
    }
    
    guard let regexp = self.regexp else {
      return .error("Не указано регулярное выражение")
    }
    
    if validatedValue.regex(pattern: regexp).isEmpty {
      return .error("Валидация по регулярному выражению не пройдена")
    }
    
    return checkNext(value: value)
  }
}
