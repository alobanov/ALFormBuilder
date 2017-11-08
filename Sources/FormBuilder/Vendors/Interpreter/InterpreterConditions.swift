//
//  ALInterpreterConditions.swift
//  Pulse
//
//  Created by Lobanov Aleksey on 16.03.17.
//  Copyright © 2017 Lobanov Aleksey Lab. All rights reserved.
//

import Foundation

public class ALInterpreterConditions {
  public init() {}
  
  public func calculateExpression(expression: String, json: [String: Any]) -> Bool {
    var exp = expression

    // Keys
    let prefixText = "@model."
    let paths = expression.regex(pattern: "\(prefixText)([a-zA-Z0-9_.\\-]+)", group: 1)

    // replace key by values
    for path in paths {
      if let str = json.value(by: path) as? String {
        if str == "" { return false }
        exp = exp.replacingOccurrences(of: "\(prefixText)\(path)", with: str)
      } else {
        exp = exp.replacingOccurrences(of: "\(prefixText)\(path)", with: "<null>")
      }
    }

    exp = precalculateBitwiseExp(exp: exp)

    let evaluator = ALEvaluator(expression: exp)
    return evaluator.interpret([String: ALExpression]())
  }
  
  public func precalculateBitwiseExp(exp: String) -> String {
    var updatedExp = exp
    let exps = exp.regex(pattern: "(\\w+\\s)[ & ]{1}(\\s\\w+)")
    
    for exp in exps {
      let variable = exp.components(separatedBy: " ")
      if variable.count == 3, let lhs = Int(variable[0]), let rhs = Int(variable[2]) {
        let result = lhs & rhs
        updatedExp = updatedExp.replacingOccurrences(of: "(\(exp))", with: String(result))
      } else {
        updatedExp = updatedExp.replacingOccurrences(of: "(\(exp))", with: "0")
      }
    }
    
    return updatedExp
  }
}
