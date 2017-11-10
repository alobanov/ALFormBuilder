//
//  ALStringValue.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ALStringValue: ALValueTransformable {
  private var originalValue: String?
  public var initialValue: String?
  public var wasModify: Bool = false
  
  public init(value: String?) {
    self.originalValue = value
    self.initialValue = transformForDisplay()
  }
  
  public func change(originalValue: Any?) {
    self.originalValue = originalValue as? String
    
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
    guard let str = self.originalValue else {
      return nil
    }
    
    return str
  }
  
  public func transformForJSON() -> JSONValueType {
    guard let str = self.originalValue else {
      return NSNull()
    }
    
    return str.isEmpty ? NSNull() : str
  }
}
