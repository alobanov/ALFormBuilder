//
//  FBEmailClosureValidation.swift
//  Puls
//
//  Created by NVV on 20/12/2017.
//  Copyright © 2017 MOPC. All rights reserved.
//

import Foundation

extension FBValidationClosures {
  
  func emailValidation() -> ALFBClosureValidation {
    let closure: (String?) -> Bool = { value in
      guard let value = value, !value.isEmpty else {
        return false
      }
      let regExp = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
      guard (!value.regex(pattern: regExp).isEmpty) else {
        return false
      }
      return true
    }
    
    let validation = ALFBClosureValidation(closure:closure,
                                           error: "Корректный формат example@domain.ru")
    
    return validation
  }
  
}
