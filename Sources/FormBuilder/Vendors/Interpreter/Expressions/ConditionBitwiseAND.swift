//
//  ConditionBitwise.swift
//  Pulse
//
//  Created by Lobanov Aleksey on 12.04.17.
//  Copyright © 2017 Lobanov Aleksey Lab. All rights reserved.
//

import Foundation

class ConditionBitwiseAND: Expression {

  var leftOperand: Expression
  var rightOperand: Expression

  init(leftOperand: Expression, rightOperand: Expression) {
    self.leftOperand = leftOperand
    self.rightOperand = rightOperand
  }

  func interpret(_ variables: [String : Expression]) -> Bool {
    // Bitwise &
    guard let r = leftOperand.numberValue(), let l = rightOperand.numberValue() else {
      return false
    }

    let result = r & l
    return (result == l)
  }
}
