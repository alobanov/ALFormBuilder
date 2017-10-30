//
//  conditionOR.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ConditionOR: Expression {

  public var leftOperand: Expression
  public var rightOperand: Expression

  public init(leftOperand: Expression, rightOperand: Expression) {
    self.leftOperand = leftOperand
    self.rightOperand = rightOperand
  }

  public func interpret(_ variables: [String : Expression]) -> Bool {
    return leftOperand.interpret(variables) || rightOperand.interpret(variables)
  }
}
