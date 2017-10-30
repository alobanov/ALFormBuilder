//
//  ButtonRowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Button form item builder
public protocol ButtonRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol {
  func define(title: String)
}

public class ButtonRowItemBuilder: RowItemBuilder, ButtonRowItemBuilderProtocol {
  private var title = ""
  
  public override init() {
    
  }
  
  public func define(title: String) {
    self.title = title
  }
  
  public override func result() -> FromItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    return RowFormButtonComposite(composite: baseComposite, visible: visibleSetting, base: base, title: self.title)
  }
}
