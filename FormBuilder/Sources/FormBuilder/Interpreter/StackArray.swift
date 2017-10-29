//
//  conditionFalse.swift
//  AlgorithmAndStructures
//
//  Created by Lobanov Aleksey on 13.03.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

struct Stack<T> {

  var items = [T]()

  mutating func push(_ item: T) {
    items.append(item)
  }

  mutating func pop() -> T {
    return items.removeLast()
  }
}
