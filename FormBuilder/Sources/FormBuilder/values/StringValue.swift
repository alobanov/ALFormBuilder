//
//  StringValue.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class StringValue: ValueTransformable {
  private var originalValue: Any?
  var initialValue: String?
  var wasModify: Bool = false
  
  init(value: String?) {
    self.originalValue = value
    self.initialValue = transformForDisplay()
  }
  
  func change(originalValue: Any?) {
    self.originalValue = originalValue
    
    if initialValue == nil, let newValue = transformForDisplay() {
      wasModify = !newValue.isEmpty
    } else {
      wasModify = (initialValue != transformForDisplay())
    }
  }
  
  func retriveOriginalValue() -> Any? {
    return originalValue
  }
  
  func transformForDisplay() -> DisplayValueType? {
    guard let str = self.originalValue as? String else {
      return nil
    }
    
    return str
  }
  
  func transformForJSON() -> JSONValueType {
    guard let str = self.originalValue as? String else {
      return NSNull()
    }
    
    return str
  }
}
