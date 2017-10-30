//
//  UniversalDatasourceModel.swift
//  Pulse
//
//  Created by MOPC on 09.10.16.
//  Copyright © 2016 MOPC Lab. All rights reserved.
//

import RxDataSources

protocol RxCellModelDatasoursable: class {
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
protocol RxCellReloadeble {
  func reload(with model: RxCellModelDatasoursable)
}

/**
 Datasource model (based on RxDatasource)
 
 - PersonalInformationSection: section of personal information
 */

struct RxSectionModel {
  var items: [RxSectionItemModel]
  var identifier: String
  var model: SectionFormComposite

  init(items: [RxSectionItemModel], model: SectionFormComposite) {
    self.items = items
    self.identifier = model.identifier
    self.model = model
  }
}

extension RxSectionModel: AnimatableSectionModelType {
  typealias Item = RxSectionItemModel
  typealias Identity = String

  var identity: String {
    return identifier
  }

  init(original: RxSectionModel, items: [Item]) {
    self = original
    self.items = items
  }
}

struct RxSectionItemModel {
  var model: RxCellModelDatasoursable

  init(model: RxCellModelDatasoursable) {
    self.model = model
  }
}

extension RxSectionItemModel: IdentifiableType, Equatable {
  typealias Identity = String

  var identity: String {
      return model.diffIdentifier ?? ""
  }
  
  func strictReload() -> Bool {
    return model.strictReload()
  }
}

// equatable, this is needed to detect changes
func == (lhs: RxSectionItemModel, rhs: RxSectionItemModel) -> Bool {
  return lhs.identity == rhs.identity && !lhs.strictReload()
}
