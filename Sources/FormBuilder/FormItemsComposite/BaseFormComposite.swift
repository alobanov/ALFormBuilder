//
//  BaseFormItemComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 26/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Base implementation of FromItemCompositeProtocol
/// For creation new model you should use Decorator pattern for
/// extended it
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
  
  public required init() {}
  
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
