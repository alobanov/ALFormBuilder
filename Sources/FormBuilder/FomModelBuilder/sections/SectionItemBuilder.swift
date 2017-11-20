//
//  SectionItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

public protocol SectionItemBuilderProtocol {
  func define(identifier: String, header: String?, footer: String?)
  func result() -> FormItemCompositeProtocol
}

public class SectionItemBuilder: SectionItemBuilderProtocol {
  private var header: String?
  private var footer: String?
  private var identifier: String = ""
  private var cellType: FBUniversalCellProtocol = ALFB.Cells.emptyField
  
  public init() {}
  
  public func define(identifier: String, header: String?, footer: String?) {
    self.identifier = identifier
    self.header = header
    self.footer = footer
  }
  
  public func result() -> FormItemCompositeProtocol {
    let base = BaseFormComposite(identifier: identifier, level: .section)
    return SectionFormComposite(composite: base, header: header, footer: footer)
  }
}
