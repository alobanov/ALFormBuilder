//
//  RowFormButtonComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol RowFormButtonCompositeOutput: RowCompositeVisibleSetting {
  var title: String {get}
}

class RowFormButtonComposite: FromItemCompositeProtocol, RowFormButtonCompositeOutput {
  // MARK :- ModelItemDatasoursable
  private let decoratedComposite: FromItemCompositeProtocol
  
  // MARK :- FromItemCompositeProtocol properties
  var level: ALFB.FormModelLevel = .item
  
  var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  var leaves: [FromItemCompositeProtocol] {
    return [self]
  }
  
  var children: [FromItemCompositeProtocol] {
    return []
  }
  
  var datasource: [FromItemCompositeProtocol] {
    return self.visible.isVisible ? [self] : []
  }
  
  // MARK :- RowFormComposite properties
  var visible: ALFB.Visible
  var base: ALFB.Base
  
  // private properties
  var title: String
  
  init(composite: FromItemCompositeProtocol, visible: ALFB.Visible, base: ALFB.Base, title: String)
  {
    self.decoratedComposite = composite
    self.visible = visible
    self.base = base
    self.title = title
  }
}
