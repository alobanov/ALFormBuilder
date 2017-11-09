//
//  ConditionMoreThen.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 01/11/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ALConditionMoreThen: ALExpression {
  
  public var leftOperand: ALExpression
  public var rightOperand: ALExpression
  
  public init(leftOperand: ALExpression, rightOperand: ALExpression) {
    self.leftOperand = leftOperand
    self.rightOperand = rightOperand
  }
  
  public func interpret(_ variables: [String : ALExpression]) -> Bool {
    // Check on number type
    switch rightOperand.context() {
    case .bool, .string, .undefined:
      return false
    case .integer, .float:
      return leftOperand.floatValue() ?? 0.0 > rightOperand.floatValue() ?? 0
    }
  }
}
