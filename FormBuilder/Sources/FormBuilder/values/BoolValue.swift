//
//  BoolValue.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit

class BoolValue: ValueTransformable {
  var originalValue: Any?
  var initialValue: String?
  var wasModify: Bool = false
  
  init(value: Bool = false) {
    self.originalValue = value
    self.initialValue = transformForDisplay()
  }
  
  func transformForDisplay() -> DisplayValueType? {
    guard let bool = self.originalValue as? Bool else {
      return nil
    }
    
    return bool ? "true" : "false"
  }
  
  func change(originalValue: Any?) {
    self.originalValue = originalValue
    wasModify = (initialValue != transformForDisplay())
  }
  
  func retriveOriginalValue() -> Any? {
    return originalValue
  }
  
  func transformForJSON() -> JSONValueType {
    guard let bool = self.originalValue as? Bool else {
      return NSNull()
    }
    
    return bool
  }
}
