//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

enum ContextType {
  case bool, number, string
}

protocol Expression {
  func numberValue() -> Int?
  func stringValue() -> String?
  func interpret(_ variables: [String: Expression]) -> Bool
  func context() -> ContextType
}

extension Expression {
  // default
  func numberValue() -> Int? {
    return nil
  }
  
  func stringValue() -> String? {
    return nil
  }

  // default context
  func context() -> ContextType {
    return .bool
  }
}
