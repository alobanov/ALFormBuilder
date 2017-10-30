//
//  PreparingMiddlewareValidation.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class PreparingMiddlewareValidation: MiddlewareValidation {
  override func check(value: String?) -> ALFB.ValidationResult {
    let check1 = value?.trimmingCharacters(in: CharacterSet.whitespaces) ?? nil
    let check2 = (check1?.isEmpty ?? true) ? nil : check1
    return checkNext(value: check2)
  }
}
