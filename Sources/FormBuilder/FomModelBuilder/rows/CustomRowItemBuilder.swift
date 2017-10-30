//
//  CustomRowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Bool form item builder
protocol CustomRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol {
  func define(title: String)
}

class CustomRowItemBuilder: RowItemBuilder, CustomRowItemBuilderProtocol {
  private var title = ""
  
  func define(title: String) {
    self.title = title
  }
  
  override func result() -> FromItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    return RowCustomComposite(composite: baseComposite, visible: visibleSetting, base: base, data: title)
  }
}
