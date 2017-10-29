//
//  BaseFormItemComposite.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 26/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol FromItemCompositeProtocol {
  var identifier: String {get}
  var level: FormModelLevel {get}
  
  var children: [FromItemCompositeProtocol] {get}
  var leaves: [FromItemCompositeProtocol] {get}
  var datasource: [FromItemCompositeProtocol] {get}
  
  func add(_ model: FromItemCompositeProtocol...)
  func remove(_ model: FromItemCompositeProtocol)
  
  func isValid() -> Bool
  func wasChanged() -> Bool
}

extension FromItemCompositeProtocol {
  func isValid() -> Bool {
    for model in children {
      if !model.isValid() {
        return false
      }
    }
    
    return true
  }
  
  func wasChanged() -> Bool {
    for model in children {
      if model.wasChanged() {
        return true
      }
    }
    
    return false
  }
  
  func add(_ model: FromItemCompositeProtocol...) {
    print("Implement this method if you want to add new child")
  }
  
  func remove(_ model: FromItemCompositeProtocol) {
    print("Implement this method if you want to remove child")
  }
}

class BaseFormComposite: FromItemCompositeProtocol {
  var children: [FromItemCompositeProtocol] = []
  
  var level: FormModelLevel = .root
  var identifier: String = "root"
  
  var leaves: [FromItemCompositeProtocol] {
    return children.flatMap{ $0.leaves }
  }
  
  var datasource: [FromItemCompositeProtocol] {
    return children
  }
  
  init() {}
  
  init(identifier: String, level: FormModelLevel) {
    self.identifier = identifier
    self.level = level
  }
  
  func add(_ model: FromItemCompositeProtocol...) {
    self.children.append(contentsOf: model)
  }
  
  func remove(_ model: FromItemCompositeProtocol) {
    if let index = self.children.index(where: { $0 == model }) {
      children.remove(at: index)
    }
  }
}

func == (lhs: FromItemCompositeProtocol, rhs: FromItemCompositeProtocol) -> Bool {
  return lhs.identifier == rhs.identifier
}
