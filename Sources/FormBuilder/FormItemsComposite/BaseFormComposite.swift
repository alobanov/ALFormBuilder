//
//  BaseFormItemComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 26/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol FromItemCompositeProtocol {
  var identifier: String {get}
  var level: ALFB.FormModelLevel {get}
  
  var children: [FromItemCompositeProtocol] {get}
  var leaves: [FromItemCompositeProtocol] {get}
  var datasource: [FromItemCompositeProtocol] {get}
  
  func add(_ model: FromItemCompositeProtocol...)
  func remove(_ model: FromItemCompositeProtocol)
  
  func isValid() -> Bool
  func wasChanged() -> Bool
}

public extension FromItemCompositeProtocol {
  public func isValid() -> Bool {
    for model in children {
      if !model.isValid() {
        return false
      }
    }
    
    return true
  }
  
  public func wasChanged() -> Bool {
    for model in children {
      if model.wasChanged() {
        return true
      }
    }
    
    return false
  }
  
  public func add(_ model: FromItemCompositeProtocol...) {
    print("Implement this method if you want to add new child")
  }
  
  public func remove(_ model: FromItemCompositeProtocol) {
    print("Implement this method if you want to remove child")
  }
}

public class BaseFormComposite: FromItemCompositeProtocol {
  public var children: [FromItemCompositeProtocol] = []
  
  public var level: ALFB.FormModelLevel = .root
  public var identifier: String = "root"
  
  public var leaves: [FromItemCompositeProtocol] {
    return children.flatMap{ $0.leaves }
  }
  
  public var datasource: [FromItemCompositeProtocol] {
    return children
  }
  
  public init(identifier: String, level: ALFB.FormModelLevel) {
    self.identifier = identifier
    self.level = level
  }
  
  public func add(_ model: FromItemCompositeProtocol...) {
    self.children.append(contentsOf: model)
  }
  
  public func remove(_ model: FromItemCompositeProtocol) {
    if let index = self.children.index(where: { $0 == model }) {
      children.remove(at: index)
    }
  }
}

public func == (lhs: FromItemCompositeProtocol, rhs: FromItemCompositeProtocol) -> Bool {
  return lhs.identifier == rhs.identifier
}
