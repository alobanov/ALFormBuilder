//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public enum ALContextType {
  case bool, number, string
}

public protocol ALExpression {
  func numberValue() -> Int?
  func stringValue() -> String?
  func interpret(_ variables: [String: ALExpression]) -> Bool
  func context() -> ALContextType
}

public extension ALExpression {
  // default
  func numberValue() -> Int? {
    return nil
  }
  
  func stringValue() -> String? {
    return nil
  }

  // default context
  func context() -> ALContextType {
    return .bool
  }
}
