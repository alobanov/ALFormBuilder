//
//  RowComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol RowCustomCompositeOutput: FormItemCompositeProtocol, RowCompositeVisibleSetting {
  var data: Any {get}
}

public class RowCustomComposite: RowCustomCompositeOutput {
  // MARK :- ModelItemDatasoursable
  private let decoratedComposite: FormItemCompositeProtocol
  
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
  
  public var items: [RxSectionItemModel] {
    return [RxSectionItemModel(model: self)]
  }
  
  public var datasource: [FormItemCompositeProtocol] {
    return self.visible.isVisible ? [self] : []
  }
  
  // MARK :- RowFormComposite properties
  public var visible: ALFB.Condition
  public var base: ALFB.Base
  
  // private properties
  public var data: Any
  
  public init(composite: FormItemCompositeProtocol, visible: ALFB.Condition, base: ALFB.Base, data: Any)
  {
    self.decoratedComposite = composite
    self.visible = visible
    self.base = base
    self.data = data
  }
}
