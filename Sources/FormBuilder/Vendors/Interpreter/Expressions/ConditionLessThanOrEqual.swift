//
//  ConditionLessThanOrEqual.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 27/03/2018.
//  Copyright © 2018 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ConditionLessThanOrEqual: ALExpression {
  
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
      return leftOperand.doubleValue() ?? 0.0 <= rightOperand.doubleValue() ?? 0
    }
  }
}
