//
//  PickerValue.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

typealias PickerValueTuple = (display: String, value: Any)

class PickerValue: ALValueTransformable {
  private var originalValue: Any?
  var initialValue: String?
  var wasModify: Bool = false
  
  init(value: PickerValueTuple?) {
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
    guard let str = self.originalValue as? PickerValueTuple else {
      return nil
    }
    
    return str.display
  }
  
  func transformForJSON() -> JSONValueType {
    guard let str = self.originalValue as? PickerValueTuple else {
      return NSNull()
    }
    
    return str.value
  }
}
