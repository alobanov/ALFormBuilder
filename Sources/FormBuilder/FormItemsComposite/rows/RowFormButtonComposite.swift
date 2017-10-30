//
//  RowFormButtonComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol RowFormButtonCompositeOutput: RowCompositeVisibleSetting {
  var title: String {get}
}

public class RowFormButtonComposite: FromItemCompositeProtocol, RowFormButtonCompositeOutput {
  // MARK :- ModelItemDatasoursable
  private let decoratedComposite: FromItemCompositeProtocol
  
  // MARK :- FromItemCompositeProtocol properties
  public var level: ALFB.FormModelLevel = .item
  
  public var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  public var leaves: [FromItemCompositeProtocol] {
    return [self]
  }
  
  public var children: [FromItemCompositeProtocol] {
    return []
  }
  
  public var datasource: [FromItemCompositeProtocol] {
    return self.visible.isVisible ? [self] : []
  }
  
  // MARK :- RowFormComposite properties
  public var visible: ALFB.Visible
  public var base: ALFB.Base
  
  // private properties
  public var title: String
  
  public init(composite: FromItemCompositeProtocol, visible: ALFB.Visible, base: ALFB.Base, title: String)
  {
    self.decoratedComposite = composite
    self.visible = visible
    self.base = base
    self.title = title
  }
}
