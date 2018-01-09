//
//  FBPhoneClosureValidation.swift
//  Puls
//
//  Created by NVV on 20/12/2017.
//  Copyright © 2017 MOPC. All rights reserved.
//

import Foundation

extension FBValidationClosures {

  func  phoneValidation() -> ALFBClosureValidation {
    let closure: (String?) -> Bool = { value in
      guard var value = value,
        !value.isEmpty
        else {
          return false
      }
      let ru_kz_starting_digit = "7"
      let ru_kz_alternative_starting_digit = "8"
      let by_starting_digits = "375"
      let ua_starting_digits = "380"
      let PHONE_NUMBER_MIN_LENGTH = 4
      let PHONE_NUMBER_MAX_LENGTH = 15
      let RU_KZ_NUMBER_LENGTH = 11
      let UA_BY_NUMBER_LENGTH = 12
      
      let phoneRegExp = "(^$|^[+]?[0-9]{\(PHONE_NUMBER_MIN_LENGTH),\(PHONE_NUMBER_MAX_LENGTH)}$)"
      guard (!value.regex(pattern: phoneRegExp).isEmpty) else {
        return false
      }
      value = value.replace(string: "+", replacement: "")
      
      let length = value.count
      if length >= PHONE_NUMBER_MIN_LENGTH, length <= PHONE_NUMBER_MAX_LENGTH {
        if value.starts(with: ru_kz_starting_digit) || value.starts(with: ru_kz_alternative_starting_digit),
          length != RU_KZ_NUMBER_LENGTH
        {
          return false
        }
        if value.starts(with: by_starting_digits) || value.starts(with: ua_starting_digits),
          length != UA_BY_NUMBER_LENGTH
        {
          return false
        }
        return true
      }
      return false
    }
    let validation = ALFBClosureValidation(closure:closure,
                                           error: "Корректный формат 89123456789")
    
    return validation
  }
  
}
