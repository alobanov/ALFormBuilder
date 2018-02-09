//
//  Phone3PartRegExpMiddlewareValidation.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 09/02/2018.
//  Copyright © 2018 Lobanov Aleksey. All rights reserved.
//

import Foundation

class Phone3PartRegExpMiddlewareValidation: MiddlewareValidation {
  private let regexp: String?
  
  init(regexp: String?) {
    self.regexp = regexp
  }
  
  override func check(value: String?) -> ALFB.ValidationResult {
    guard let validatedValue = value else {
      return .error("Значение пустое")
    }
    
    let phoneParts = validatedValue.components(separatedBy: " ")
    
    if phoneParts.count != 3 {
      return .error("Должно быть 3 части телефона")
    }
    
    if let regext = self.regexp {
      let phone = phoneParts[2]
      if phone.regex(pattern: regext).isEmpty {
        return .error("Валидация по регулярному выражению не пройдена")
      }
    }
    
    return checkNext(value: value)
  }
}
