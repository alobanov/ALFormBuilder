//
//  SectionFormItemComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 26/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol SectionFormCompositeOutput {
  var header: String? {get}
  var footer: String? {get}
}

public class SectionFormComposite: FromItemCompositeProtocol, SectionFormCompositeOutput {
  private let decoratedComposite: FromItemCompositeProtocol
  
  public var header: String?
  public var footer: String?
  
  // MARK :- FromItemCompositeProtocol properties
  public var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  public var children: [FromItemCompositeProtocol] {
    return self.decoratedComposite.children
  }
  
  public var datasource: [FromItemCompositeProtocol] {
    return self.decoratedComposite.children.flatMap {$0.datasource}
  }
  
  public var leaves: [FromItemCompositeProtocol] {
    return self.decoratedComposite.leaves.flatMap{ $0.leaves }
  }
  
  public var level: ALFB.FormModelLevel = .section
  
  public init(composite: FromItemCompositeProtocol, header: String?, footer: String?) {
    self.decoratedComposite = composite
    self.header = header
    self.footer = footer
  }
  
  // MARK :- FromItemCompositeProtocol methods
  
  public func add(_ model: FromItemCompositeProtocol...) {
    for item in model {
      if item.level != .section {
        self.decoratedComposite.add(item)
      } else {
        print("You can`t add section in other section")
      }
    }
  }
  
  public func remove(_ model: FromItemCompositeProtocol) {
    self.decoratedComposite.remove(model)
  }
}
