//
//  RowComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol RowCustomCompositeOutput: RowCompositeVisibleSetting {
  var data: Any {get}
}

class RowCustomComposite: FromItemCompositeProtocol, RowCustomCompositeOutput {
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
  var data: Any
  
  init(composite: FromItemCompositeProtocol, visible: ALFB.Visible, base: ALFB.Base, data: Any)
  {
    self.decoratedComposite = composite
    self.visible = visible
    self.base = base
    self.data = data
  }
}
