//
//  conditionAND.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class ConditionAND: Expression {

  var leftOperand: Expression
  var rightOperand: Expression

  init(leftOperand: Expression, rightOperand: Expression) {
    self.leftOperand = leftOperand
    self.rightOperand = rightOperand
  }

  func interpret(_ variables: [String : Expression]) -> Bool {
    return leftOperand.interpret(variables) && rightOperand.interpret(variables)
  }
}
