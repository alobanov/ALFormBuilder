//
//  IntValue.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 01/11/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ALIntValue: ALValueTransformable {
  private var originalValue: Int?
  public var initialValue: String?
  public var wasModify: Bool = false
  
  public init(value: Int?) {
    self.originalValue = value
    self.initialValue = transformForDisplay()
  }
  
  public func change(originalValue: Any?) {
    self.originalValue = originalValue as? Int
    
    if initialValue == nil, let newValue = transformForDisplay() {
      wasModify = !newValue.isEmpty
    } else {
      wasModify = (initialValue != transformForDisplay())
    }
  }
  
  public func retriveOriginalValue() -> Any? {
    return originalValue
  }
  
  public func transformForDisplay() -> DisplayValueType? {
    guard let value = self.originalValue else {
      return nil
    }
    
    return String(value)
  }
  
  public func transformForJSON() -> JSONValueType {
    guard let str = self.originalValue else {
      return NSNull()
    }
    
    return str
  }
}
