//
//  ValueTransformable.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol ValueTransformable {
  typealias DisplayValueType = String
  typealias JSONValueType = Any
  
  var initialValue: String? { get }
  var wasModify: Bool { get }
  
  func transformForDisplay() -> DisplayValueType?
  func transformForJSON() -> JSONValueType
  
  func change(originalValue: Any?)
  func retriveOriginalValue() -> Any?
}

class Vvv<T> {
  typealias DisplayValueType = String
  typealias JSONValueType = Any
  
  var originalValue: T?
  var initialValue: String?
  var wasModify: Bool = false
  
  init(value: T?) {
    self.originalValue = value
    self.initialValue = transformForDisplay()
  }
  
  func change(originalValue: T?) {
    self.originalValue = originalValue
    wasModify = (initialValue != transformForDisplay())
  }
  
  func retriveOriginalValue() -> T? {
    return originalValue
  }
  
  func transformForDisplay() -> DisplayValueType? {
    return ""
  }
  
  func transformForJSON() -> JSONValueType {
    return ""
  }
}

protocol VvvTransformable {
  associatedtype T
  func retriveOriginalValue() -> T?
  func change(originalValue: T?)
  var wasModify: Bool {get}
}

class BoolVvv: Vvv<Bool>, VvvTransformable {
  override func transformForDisplay() -> DisplayValueType? {
    guard let bool = self.originalValue else {
      return nil
    }
    
    return bool ? "true" : "false"
  }
  
  override func transformForJSON() -> JSONValueType {
    guard let bool = self.originalValue else {
      return NSNull()
    }
    
    return bool
  }
}


