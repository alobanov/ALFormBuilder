//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public class ALEvaluator: ALExpression {
  public var syntaxTree: ALExpression = ALVariableExpression(name: "false")
  public var expression: String

  public init (expression: String) {
    self.expression = expression
  }

  fileprivate func buildSyntaxTree() {
    var expressionStack = ALStack<ALExpression>()

    var items = expression.components(separatedBy: " ")

    var index = 0

    while index < items.count {

      switch items[index] {
      case "==":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ALConditionTrue(leftOperand: expressionStack.pop(),
                                      rightOperand: nextExpression))
        index += 2
      case "!=":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ALConditionFalse(leftOperand: expressionStack.pop(),
                                    rightOperand: nextExpression))
        index += 2

      case "||":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ALConditionOR(leftOperand: expressionStack.pop(),
                                            rightOperand: nextExpression))
        index += 2

      case "&&":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ALConditionAND(leftOperand: expressionStack.pop(),
                                            rightOperand: nextExpression))
        index += 2
        
      case ">":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ALConditionMoreThen(leftOperand: expressionStack.pop(),
                                                   rightOperand: nextExpression))
        index += 2
      
      case "<":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ALConditionLessThen(leftOperand: expressionStack.pop(),
                                                 rightOperand: nextExpression))
        index += 2
        
      case "<=":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ConditionLessThanOrEqual(leftOperand: expressionStack.pop(),
                                                      rightOperand: nextExpression))
        index += 2

      case "<=":
        let nextExpression = getNextExpression(items, index: index)
        expressionStack.push(ConditionMoreThanOrEqual(leftOperand: expressionStack.pop(),
                                                      rightOperand: nextExpression))
        index += 2
        
      default:
          expressionStack.push(ALVariableExpression(name: items[index]))
          index += 1
      }

    }
    syntaxTree = expressionStack.pop()
  }

  fileprivate func getNextExpression(_ items: [String], index: Int) ->ALExpression {
    let next = items[index + 1]
    let nextExpression = ALVariableExpression(name: next)
    return nextExpression
  }

  fileprivate func parseoutAdditionsAndSubtractions(_ input: String) -> [String] {
    var result = [String]()
    let items = input.components(separatedBy: " ")

    var sentence = ""
    var index = 0
    for item in items {
      if item == "&&" || item == "||" {
        result.append(sentence.trim())
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

  public func interpret(_ variables: [String: ALExpression]) -> Bool {

    if (expression.contains("||") || expression.contains("&&")) &&
       (expression.contains("==") || expression.contains("!=")
      || expression.contains("<") || expression.contains(">")
      || expression.contains("<=") || expression.contains(">="))
    {
      let expressions = parseoutAdditionsAndSubtractions(expression)
      var newExpression = ""
      var index = 0
      for expression in expressions {
        if expression == "||" || expression == "&&" {
          newExpression += expression
        } else {
          let eval = ALEvaluator(expression: expression)
          let result = eval.interpret(variables)
          newExpression += String(result)
        }

        if index != expressions.count - 1 {
          newExpression += " "
        }
        index += 1
      }

      let evaluator = ALEvaluator(expression: newExpression)
      return evaluator.interpret(variables)
    } else {
      buildSyntaxTree()
      return syntaxTree.interpret(variables)
    }
  }
}
