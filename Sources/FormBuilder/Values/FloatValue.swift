//
//  FloatValue.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 08/11/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ALFloatValue: ALValueTransformable {
  private var originalValue: Float?
  public var initialValue: String?
  public var wasModify: Bool = false
  
  private var dotsCount = 0
  
  public init(value: Float?) {
    self.originalValue = value
    
    if var val = value {
      while val > 0.0 {
        val /= 10.0
        dotsCount += 1
      }
    }
    
    self.initialValue = transformForDisplay()
  }
  
  public func change(originalValue: Any?) {
//    if let str = originalValue as? String {
//      let comps = str.components(separatedBy: ".")
//      if comps.count > 1 {
//        dotsCount = comps[1].count
//      }
//    }
//    self.originalValue = Float(originalValue as? String ?? "0.0")
    self.originalValue = originalValue as? Float
    
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
    guard let value = self.originalValue else {
      return NSNull()
    }
    
    let fmt = NumberFormatter()
    fmt.locale = Locale(identifier: "en_US_POSIX")
    fmt.maximumFractionDigits = 3
    fmt.minimumFractionDigits = 0
    return fmt.string(from: NSNumber(value: value)) ?? NSNull()
  }
}
