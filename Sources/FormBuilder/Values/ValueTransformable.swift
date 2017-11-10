//
//  ValueTransformable.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol ALValueTransformable {
  typealias DisplayValueType = String
  typealias JSONValueType = Any
  
  var initialValue: String? { get }
  var wasModify: Bool { get }
  
  func transformForDisplay() -> DisplayValueType?
  func transformForJSON() -> JSONValueType
  
  func change(originalValue: Any?)
  func retriveOriginalValue() -> Any?
}
