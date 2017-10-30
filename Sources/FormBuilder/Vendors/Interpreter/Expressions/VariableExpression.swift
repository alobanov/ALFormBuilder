//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class VariableExpression: Expression {
  fileprivate var name: String

  public init(name: String) {
    self.name = name
  }

  public func context() -> ContextType {
    if self.name.contains("`") {
      return .string
    }
    
    return self.numberValue() != nil ? .number : .bool
  }

  public func interpret(_ variables: [String : Expression]) -> Bool {
    if let expression = variables[name] {
      return expression.interpret(variables)
    } else {
      switch self.name {
      case "true":
        return true
      default:
        return false
      }
    }
  }
  
  public func stringValue() -> String? {
    if self.name.contains("`") {
      return self.name.replace(string: "`", replacement: "")
    } else {
      return self.name
    }
  }

  public func numberValue() -> Int? {
    switch self.name {
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
}
