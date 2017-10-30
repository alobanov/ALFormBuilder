//
//  BoolRowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Bool form item builder
protocol BoolRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol,
RowItemValueBuilderProtocol, RowItemValidationBuilderProtocol {
  func define(title: String)
}

class BoolRowItemBuilder: RowItemBuilder, BoolRowItemBuilderProtocol {
  private var title = ""
  
  func define(title: String) {
    self.title = title
  }
  
  override func result() -> FromItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    return RowFormBoolComposite(composite: baseComposite, value: self.value, visible: visibleSetting, base: base, validation: validation, title: title)
  }
}
