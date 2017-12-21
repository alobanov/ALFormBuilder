//
//  UniversalDatasourceModel.swift
//  Pulse
//
//  Created by Aleksey Lobanov on 09.10.16.
//  Copyright © 2016 Aleksey Lobanov All rights reserved.
//

import RxDataSources

public protocol RxCellModelDatasoursable: class {
  var diffIdentifier: String? { get }
  var cellType: FBUniversalCellProtocol { get }
  var identifier: String {get}
  func strictReload() -> Bool
}

extension RxCellModelDatasoursable {
  func strictReload() -> Bool {
    return false
  }
}

/**
 *  Reloadeble protocol for all registration cell
 */
public protocol RxCellReloadeble {
  func reload(with model: RxCellModelDatasoursable)
}

/**
 Datasource model (based on RxDatasource)
 
 - PersonalInformationSection: section of personal information
 */

public struct RxSectionModel {
  public var items: [RxSectionItemModel]
  public var identifier: String
  public var model: SectionFormComposite

  public init(items: [RxSectionItemModel], model: SectionFormComposite) {
    self.items = items
    self.identifier = model.identifier
    self.model = model
  }
}

extension RxSectionModel: AnimatableSectionModelType {
  public typealias Item = RxSectionItemModel
  public typealias Identity = String

  public var identity: String {
    return identifier
  }

  public init(original: RxSectionModel, items: [Item]) {
    self = original
    self.items = items
  }
}

public struct RxSectionItemModel {
  public var model: RxCellModelDatasoursable

  public init(model: RxCellModelDatasoursable) {
    self.model = model
  }
}

extension RxSectionItemModel: IdentifiableType, Equatable {
  public typealias Identity = String

  public var identity: String {
      return model.diffIdentifier ?? ""
  }
  
  var diff: String {
    return model.diffIdentifier ?? ""
  }
  
  public func strictReload() -> Bool {
    return model.strictReload()
  }
}

// equatable, this is needed to detect changes
public func == (lhs: RxSectionItemModel, rhs: RxSectionItemModel) -> Bool {
  return lhs.identity == rhs.identity && !lhs.strictReload() && lhs.diff == rhs.diff
}
