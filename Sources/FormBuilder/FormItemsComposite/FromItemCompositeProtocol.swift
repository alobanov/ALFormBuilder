//
//  FormItemCompositeProtocol.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 09/11/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Common `FormItem` protocol which should implement all of tree items
public protocol FormItemCompositeProtocol {
  // MARK: - Property
  // Unic identifier for each model
  var identifier: String {get}
  // Nested level of tree structure
  var level: ALFB.FormModelLevel {get}
  // children nodes
  var children: [FormItemCompositeProtocol] {get}
  // Retrieve only leaves of all tree structure
  var leaves: [FormItemCompositeProtocol] {get}
  // Retrieve items for render via table or collection view as raw type
  var datasource: [FormItemCompositeProtocol] {get}
  
  // MARK: - Methods
  // Add child item
  func add(_ model: FormItemCompositeProtocol...)
  // Remove child item
  func remove(_ model: FormItemCompositeProtocol)
  // Check validation for through tree
  func isValid() -> Bool
  // Check for changing initial state of all tree
  func wasChanged() -> Bool
}

// MARK: - Extension
/// Default implementation of common methods
public extension FormItemCompositeProtocol {
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
  
  public func add(_ model: FormItemCompositeProtocol...) {
    print("Implement this method if you want to add new child")
  }
  
  public func remove(_ model: FormItemCompositeProtocol) {
    print("Implement this method if you want to remove child")
  }
}
