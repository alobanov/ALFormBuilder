//
//  ConditionBitwise.swift
//  Pulse
//
//  Created by Lobanov Aleksey on 12.04.17.
//  Copyright © 2017 Lobanov Aleksey Lab. All rights reserved.
//

import Foundation

public class ALConditionBitwiseAND:ALExpression {

  public var leftOperand:ALExpression
  public var rightOperand:ALExpression

  init(leftOperand:ALExpression, rightOperand:ALExpression) {
    self.leftOperand = leftOperand
    self.rightOperand = rightOperand
  }

  public func interpret(_ variables: [String :ALExpression]) -> Bool {
    // Bitwise &
    guard let r = leftOperand.numberValue(), let l = rightOperand.numberValue() else {
      return false
    }

    let result = r & l
    return (result == l)
  }
}
