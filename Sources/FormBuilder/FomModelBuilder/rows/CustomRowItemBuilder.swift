//
//  CustomRowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Bool form item builder
public protocol CustomRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol {
  func define(title: String)
}

public class CustomRowItemBuilder: RowItemBuilder, CustomRowItemBuilderProtocol {
  private var title = ""
  
  public override init() {
    
  }
  
  public func define(title: String) {
    self.title = title
  }
  
  public override func result() -> FromItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    return RowCustomComposite(composite: baseComposite, visible: visibleSetting, base: base, data: title)
  }
}
