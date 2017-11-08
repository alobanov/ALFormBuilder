//
//  ConditionLessThen.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 01/11/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ALConditionLessThen: ALExpression {
  
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
    case .number:
      return leftOperand.numberValue() ?? 0 < rightOperand.numberValue() ?? 0
    }
  }
}
