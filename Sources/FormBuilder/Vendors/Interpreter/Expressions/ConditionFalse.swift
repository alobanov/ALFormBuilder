//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ALConditionFalse: ALExpression {

  var leftOperand: ALExpression
  var rightOperand: ALExpression

  public init(leftOperand: ALExpression, rightOperand: ALExpression) {
    self.leftOperand = leftOperand
    self.rightOperand = rightOperand
  }

  public func interpret(_ variables: [String : ALExpression]) -> Bool {
    switch rightOperand.context() {
    case .bool:
      return leftOperand.interpret(variables) != rightOperand.interpret(variables)
    case .integer:
      return leftOperand.integerValue() != rightOperand.integerValue()
    case .string, .float:
      return leftOperand.stringValue() != rightOperand.stringValue()    
    case .undefined:
      return false
    }
  }
}
