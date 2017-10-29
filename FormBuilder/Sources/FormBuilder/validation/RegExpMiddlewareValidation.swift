//
//  RegExpMiddlewareValidation.swift
//  FormBuilder
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
  
  override func check(value: String?) -> ValidationResult {
    guard let validatedValue = value else {
      let d = [NSLocalizedDescriptionKey: "Значение пустое"]
      let e = NSError(domain: "ru.alobanov", code: 1, userInfo: d)
      return .error(e)
    }
    
    guard let regexp = self.regexp else {
      let d = [NSLocalizedDescriptionKey: "Не указано регулярное выражение"]
      let e = NSError(domain: "ru.alobanov", code: 1, userInfo: d)
      return .error(e)
    }
    
    if validatedValue.regex(pattern: regexp).isEmpty {
      let d = [NSLocalizedDescriptionKey: "Валидация по регулярному выражению не пройдена"]
      let e = NSError(domain: "ru.alobanov", code: 1, userInfo: d)
      return .error(e)
    }
    
    return checkNext(value: value)
  }
}
