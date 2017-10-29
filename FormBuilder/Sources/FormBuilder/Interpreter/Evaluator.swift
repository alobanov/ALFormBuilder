//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class Evaluator: Expression {
  var syntaxTree: Expression = VariableExpression(name: "false")
  var expression: String

  init (expression: String) {
    self.expression = expression
  }

  fileprivate func buildSyntaxTree() {
    var expressionStack = Stack<Expression>()

    var items = expression.components(separatedBy: " ")

    var index = 0

    while index < items.count {

      switch items[index] {
      case "==":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ConditionTrue(leftOperand: expressionStack.pop(),
                                      rightOperand: nextExpression))
        index += 2
      case "!=":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ConditionFalse(leftOperand: expressionStack.pop(),
                                    rightOperand: nextExpression))
        index += 2

      case "||":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ConditionOR(leftOperand: expressionStack.pop(),
                                            rightOperand: nextExpression))
        index += 2

      case "&&":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ConditionAND(leftOperand: expressionStack.pop(),
                                            rightOperand: nextExpression))
        index += 2

      case "BitwiseAND":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ConditionBitwiseAND(leftOperand: expressionStack.pop(),
                                                 rightOperand: nextExpression))
        index += 2

      default:
          expressionStack.push(VariableExpression(name: items[index]))
          index += 1
      }

    }
    syntaxTree = expressionStack.pop()
  }

  fileprivate func getNextExpression(_ items: [String], index: Int) -> Expression {
    let next = items[index + 1]
    var nextExpression: Expression
    nextExpression = VariableExpression(name: next)

    return nextExpression
  }

  fileprivate func parseoutAdditionsAndSubtractions(_ input: String) -> [String] {
    var result = [String]()

    let items = input.components(separatedBy: " ")

    var sentence = ""
    var index = 0
    for item in items {
      if item == "&&" || item == "||" {
        result.append(sentence.trimmingCharacters(in: CharacterSet.whitespaces))
        result.append(item)
        sentence = ""
      } else {
        sentence += item
        if index != items.count - 1 {
          sentence += " "
        }
      }
      index += 1
    }
    result.append(sentence)
    return result
  }

  func interpret(_ variables: [String : Expression]) -> Bool {

    if (expression.contains("||") || expression.contains("&&")) &&
      (expression.contains("==") || expression.contains("!=") || expression.contains("BitwiseAND")) {

      let expressions = parseoutAdditionsAndSubtractions(expression)
      var newExpression = ""
      var index = 0
      for expression in expressions {
        if expression == "||" || expression == "&&" {
          newExpression += expression
        } else {
          let eval = Evaluator(expression: expression)
          let result = eval.interpret(variables)
          newExpression += String(result)
        }

        if index != expressions.count - 1 {
          newExpression += " "
        }
        index += 1
      }
      let evaluator = Evaluator(expression: newExpression)
      return evaluator.interpret(variables)
    } else {
      buildSyntaxTree()
      return syntaxTree.interpret(variables)
    }
  }
}
