//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ALVariableExpression: ALExpression {
  fileprivate var name: String

  public init(name: String) {
    self.name = name
  }

  public func context() -> ALContextType {
    if name.contains("`") {
      return .string
    } else if name.contains(".") {
      return .float
    } else if self.integerValue() != nil {
      return .integer
    } else {
      return .bool
    }
  }

  public func interpret(_ variables: [String : ALExpression]) -> Bool {
    if let expression = variables[name] {
      return expression.interpret(variables)
    } else {
      switch name {
      case "true":
        return true
      default:
        return false
      }
    }
  }
  
  public func stringValue() -> String? {
    if name.contains("`") {
      return name.replace(string: "`", replacement: "")
    } else {
      return name
    }
  }

  public func integerValue() -> Int? {
    switch name {
    case "true", "false":
      return nil
      
    case "null", "<null>":
      return -1
      
    default:
      if name.isEmpty {
        return -1
      } else {
        if let number = name.strToInt {
          return number
        } else {
          return 1
        }
      }
    }
  }
  
  public func floatValue() -> Float? {
    return name.strToFloat
  }
}
