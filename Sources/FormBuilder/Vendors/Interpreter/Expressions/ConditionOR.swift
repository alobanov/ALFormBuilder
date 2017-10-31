//
//  conditionOR.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ALConditionOR: ALExpression {

  public var leftOperand: ALExpression
  public var rightOperand: ALExpression

  public init(leftOperand: ALExpression, rightOperand: ALExpression) {
    self.leftOperand = leftOperand
    self.rightOperand = rightOperand
  }

  public func interpret(_ variables: [String : ALExpression]) -> Bool {
    return leftOperand.interpret(variables) || rightOperand.interpret(variables)
  }
}
