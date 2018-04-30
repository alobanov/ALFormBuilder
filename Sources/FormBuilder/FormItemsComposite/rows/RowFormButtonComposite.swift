//
//  RowFormButtonComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol RowFormButtonCompositeOutput: FormItemCompositeProtocol, RowCompositeVisibleSetting {
  var title: String {get}
}

public class RowFormButtonComposite: RowFormButtonCompositeOutput {
  
  // MARK :- ModelItemDatasoursable
  private var decoratedComposite: FormItemCompositeProtocol
  
  // MARK :- FormItemCompositeProtocol properties
  public var level: ALFB.FormModelLevel {
    return self.decoratedComposite.level
  }
  
  public var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  public var leaves: [FormItemCompositeProtocol] {
    return [self]
  }
  
  public var children: [FormItemCompositeProtocol] {
    return []
  }
  
  public var datasource: [FormItemCompositeProtocol] {
    return self.visible.isVisible ? [self] : []
  }
  
  public var customData: Any? {
    get { return self.decoratedComposite.customData }
    set(new) { self.decoratedComposite.customData = new }
  }
  
  // MARK :- RowFormComposite properties
  public var visible: ALFB.Condition
  public var base: ALFB.Base
  
  // private properties
  public var title: String
  
  public init(composite: FormItemCompositeProtocol, visible: ALFB.Condition, base: ALFB.Base, title: String)
  {
    self.decoratedComposite = composite
    self.visible = visible
    self.base = base
    self.title = title
  }
}
