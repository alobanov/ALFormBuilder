//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class ConditionFalse: Expression {

  var leftOperand: Expression
  var rightOperand: Expression

  init(leftOperand: Expression, rightOperand: Expression) {
    self.leftOperand = leftOperand
    self.rightOperand = rightOperand
  }

  func interpret(_ variables: [String : Expression]) -> Bool {
    // Check on number type
    switch rightOperand.context() {
    case .bool:
      return leftOperand.interpret(variables) != rightOperand.interpret(variables)
    case .number:
      return leftOperand.numberValue() != rightOperand.numberValue()
    case .string:
      return leftOperand.stringValue() != rightOperand.stringValue()
    }
  }
}
