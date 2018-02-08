//
//  SectionFormItemComposite.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 26/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit

public protocol SectionFormCompositeOutput {
  var header: String? {get}
  var footer: String? {get}
}

public class SectionFormComposite: FormItemCompositeProtocol, SectionFormCompositeOutput {
  // MARK: - SectionFormCompositeOutput
  public var header: String?
  public var footer: String?
  
  // MARK: - Provate propery
  private let decoratedComposite: FormItemCompositeProtocol
  
  // MARK: - FormItemCompositeProtocol properties
  public var identifier: String {
    return self.decoratedComposite.identifier
  }
  
  public var children: [FormItemCompositeProtocol] {
    return self.decoratedComposite.children
  }
  
  public var datasource: [FormItemCompositeProtocol] {
    return self.decoratedComposite.children.flatMap { $0.datasource }
  }
  
  public var leaves: [FormItemCompositeProtocol] {
    return self.decoratedComposite.leaves.flatMap { $0.leaves }
  }
  
  public var items: [RxSectionItemModel] {
    return self.decoratedComposite.children.flatMap {$0.items}
  }
  
  public var level: ALFB.FormModelLevel = .section
  
  public init(composite: FormItemCompositeProtocol, header: String?, footer: String?) {
    self.decoratedComposite = composite
    self.header = header
    self.footer = footer
  }
  
  public init(identifier: String, header: String? = nil, footer: String? = nil) {
    let composite = BaseFormComposite(identifier: identifier, level: ALFB.FormModelLevel.section)
    self.decoratedComposite = composite
    self.header = header
    self.footer = footer
  }
  
  // MARK :- FormItemCompositeProtocol methods
  
  public func add(_ model: FormItemCompositeProtocol...) {
    for item in model {
      if item.level != .section {
        self.decoratedComposite.add(item)
      } else {
        print("You can`t add section in other section")
      }
    }
  }
  
  public func remove(_ model: FormItemCompositeProtocol) {
    self.decoratedComposite.remove(model)
  }
  
  public func heightHeader(byWidth: CGFloat, heightOffset: CGFloat, fontSize: CGFloat) -> CGFloat {
    if header?.isEmpty ?? false || header == nil {
      return 0
    }
    
    return self.height(string: header ?? "", width: byWidth, heightOffset: heightOffset, fontSize: fontSize)
  }
  
  public func heightFooter(byWidth: CGFloat, heightOffset: CGFloat, fontSize: CGFloat) -> CGFloat {
    if footer?.isEmpty ?? false {
      return 0
    }
    
    return self.height(string: footer ?? "", width: byWidth, heightOffset: heightOffset, fontSize: fontSize)
  }
  
  private func height(string: String, width: CGFloat, heightOffset: CGFloat, fontSize: CGFloat) -> CGFloat {
    let attr = AZTextFrameAttributes(string: string, width: width, font: UIFont.systemFont(ofSize: fontSize))
    return AZTextFrame(attributes: attr).height + heightOffset
  }
  
  public func removeAll() {
    for item in self.children {
      self.remove(item)
    }
  }
}
