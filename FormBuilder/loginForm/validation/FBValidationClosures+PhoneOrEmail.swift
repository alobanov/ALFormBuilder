//
//  FBPhoneOrEmailClosureValidation.swift
//  Puls
//
//  Created by NVV on 20/12/2017.
//  Copyright © 2017 MOPC. All rights reserved.
//

import Foundation

extension FBValidationClosures {
  
  func phoneOrEmaliValidation() -> ALFBClosureValidation {
    let phoneCheck = phoneValidation().closure
    let emailCheck = emailValidation().closure
    let closure: (String?) -> Bool = { value in
      let isValid = phoneCheck(value) || emailCheck(value)
      return isValid
    }
    let validation = ALFBClosureValidation(closure: closure, error: "Корректный формат example@domain.ru или 89123456789")
    return validation
  }
  
}
