//
//  SectionFormItemComposite.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 26/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol SectionFormCompositeOutput {
  var header: String {get}
  var footer: String {get}
}

class SectionFormComposite: FromItemCompositeProtocol, SectionFormCompositeOutput {
  private let decoratedComposite: FromItemCompositeProtocol
  
  var header: String = ""
  var footer: String = ""
  
  // MARK :- FromItemCompositeProtocol properties
  var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  var children: [FromItemCompositeProtocol] {
    return self.decoratedComposite.children
  }
  
  var datasource: [FromItemCompositeProtocol] {
    return self.decoratedComposite.children.flatMap {$0.datasource}
  }
  
  var leaves: [FromItemCompositeProtocol] {
    return self.decoratedComposite.leaves.flatMap{ $0.leaves }
  }
  
  var level: FormModelLevel = .section
  
  init(composite: FromItemCompositeProtocol, header: String = "", footer: String = "") {
    self.decoratedComposite = composite
    self.header = header
    self.footer = footer
  }
  
  // MARK :- FromItemCompositeProtocol methods
  
  func add(_ model: FromItemCompositeProtocol...) {
    for item in model {
      if item.level != .section {
        self.decoratedComposite.add(item)
      } else {
        print("You can`t add section in other section")
      }
    }
  }
  
  func remove(_ model: FromItemCompositeProtocol) {
    self.decoratedComposite.remove(model)
  }
}
