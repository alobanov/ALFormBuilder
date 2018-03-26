//
//  BoolRowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Bool form item builder
public protocol BoolRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol,
RowItemValueBuilderProtocol, RowItemValidationBuilderProtocol {
  func define(title: String)
}

public class BoolRowItemBuilder: RowItemBuilder, BoolRowItemBuilderProtocol {
  private var title = ""
  
  public override init() {
    
  }
  
  public func define(title: String) {
    self.title = title
  }
  
  public override func result() -> FormItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    baseComposite.customData = customData
    return RowFormBoolComposite(composite: baseComposite, value: self.value, visible: visibleSetting, base: base, validation: validation, title: title)
  }
}
