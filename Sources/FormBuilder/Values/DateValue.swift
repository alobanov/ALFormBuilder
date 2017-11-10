//
//  ALDateValue.swift
//  Puls
//
//  Created by NVV on 01/11/2017.
//  Copyright © 2017 Aleksey Lobanov. All rights reserved.
//

import Foundation

public class ALDateValue: ALValueTransformable {
  
  private var originalValue: Date?
  public var initialValue: String?
  public var wasModify: Bool = false
  
  private var formatterForDisplay: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "E, d MMM, HH:mm"
    return formatter
  }
  
  private var formatterForJson: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
  }
  
  public init(value: Date?, displayFormat: String? = nil, jsonFormat: String? = nil) {
    if let displayFormat = displayFormat {
      formatterForDisplay.dateFormat = displayFormat
    }
    if let jsonFormat = jsonFormat {
      formatterForJson.dateFormat = jsonFormat
    }
    self.originalValue = value
    self.initialValue = transformForDisplay()
  }
  
  public func change(originalValue: Any?) {
    self.originalValue = originalValue as? Date
    
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
    guard let date = self.originalValue else {
      return nil
    }
    return formatterForDisplay.string(from: date)
  }
  
  public func transformForJSON() -> JSONValueType {
    guard let date = self.originalValue else {
      return NSNull()
    }
    return formatterForJson.string(from: date)
  }
}
