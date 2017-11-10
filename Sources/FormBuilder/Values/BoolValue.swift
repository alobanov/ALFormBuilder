//
//  ALBoolValue.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit

public class ALBoolValue: ALValueTransformable {
  private var originalValue: Bool?
  public var initialValue: String?
  public var wasModify: Bool = false
  
  public init(value: Bool = false) {
    self.originalValue = value
    self.initialValue = transformForDisplay()
  }
  
  public func transformForDisplay() -> DisplayValueType? {
    guard let bool = self.originalValue else {
      return nil
    }
    
    return bool ? "true" : "false"
  }
  
  public func change(originalValue: Any?) {
    self.originalValue = originalValue as? Bool
    wasModify = (initialValue != transformForDisplay())
  }
  
  public func retriveOriginalValue() -> Any? {
    return originalValue
  }
  
  public func transformForJSON() -> JSONValueType {
    guard let bool = self.originalValue else {
      return NSNull()
    }
    
    return bool
  }
}
