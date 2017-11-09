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
  
  private let formatter: NumberFormatter = {
    let fmt = NumberFormatter()
    fmt.locale = Locale(identifier: "en_US_POSIX")
    fmt.numberStyle = NumberFormatter.Style.decimal
    fmt.roundingMode = NumberFormatter.RoundingMode.halfUp
    fmt.minimumFractionDigits = 0
    return fmt
  }()
  
  public init(value: Float?, maximumFractionDigits: Int = Int.max) {
    self.originalValue = value
    self.formatter.maximumFractionDigits = maximumFractionDigits
    self.initialValue = transformForDisplay()
  }
  
  public func change(originalValue: Any?) {
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
    return formatter.string(from: NSNumber(value: value)) ?? NSNull()
  }
}
