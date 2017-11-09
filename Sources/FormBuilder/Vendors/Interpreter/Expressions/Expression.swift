//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public enum ALContextType {
  case bool, integer, float, string, undefined
}

public protocol ALExpression {
  func integerValue() -> Int?
  func stringValue() -> String?
  func floatValue() -> Float?
  
  func interpret(_ variables: [String: ALExpression]) -> Bool
  func context() -> ALContextType
}

public extension ALExpression {
  // default
  func integerValue() -> Int? {
    return nil
  }
  
  func floatValue() -> Float? {
    return nil
  }
  
  func stringValue() -> String? {
    return nil
  }

  // default context
  func context() -> ALContextType {
    return .undefined
  }
}
