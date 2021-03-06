//
//  PickerValue.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public typealias ALTitledTuple = (title: String?, value: Any?)

public class ALTitledValue: ALValueTransformable {
  private var originalValue: Any?
  public var initialValue: String?
  public var wasModify: Bool = false
  
  public init(value: ALTitledTuple?) {
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
    guard let tuple = self.originalValue as? ALTitledTuple,
          let title = tuple.title
    else {
      return nil
    }
    return title
  }
  
  public func transformForJSON() -> JSONValueType {
    guard let tuple = self.originalValue as? ALTitledTuple,
          let value = tuple.value
    else {
      return NSNull()
    }
    return value
  }
}
