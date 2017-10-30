//
//  PhoneMiddlewareValidation.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class PhoneMiddlewareValidation: MiddlewareValidation {
  override func check(value: String?) -> ALFB.ValidationResult {
    guard let validatedValue = value else {
      return .error("Значение пустое")
    }
      
    let phoneParts = validatedValue.components(separatedBy: " ")
    
    if phoneParts.count != 3 {
      return .error("Должно быть 3 части телефона")
    }
    
    for str in phoneParts where str.isEmpty {
      return .error("Одна из частей телефона пустая")
    }
    
    return checkNext(value: value)
  }
}
