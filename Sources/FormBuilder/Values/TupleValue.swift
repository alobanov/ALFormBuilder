//
//  PickerValue.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public typealias ALTupleValue = (display: String, value: Any)

public class TupleValue: ALValueTransformable {
  private var originalValue: Any?
  public var initialValue: String?
  public var wasModify: Bool = false
  
  public init(value: ALTupleValue?) {
    self.originalValue = value
    self.initialValue = transformForDisplay()
  }
  
  public func change(originalValue: Any?) {
    self.originalValue = originalValue
    
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
    guard let str = self.originalValue as? ALTupleValue else {
      return nil
    }
    
    return str.display
  }
  
  public func transformForJSON() -> JSONValueType {
    guard let str = self.originalValue as? ALTupleValue else {
      return NSNull()
    }
    
    return str.value
  }
}