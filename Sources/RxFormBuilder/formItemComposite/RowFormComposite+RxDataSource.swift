//
//  RowFormComposite+RxDataSource.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

extension RowFormTextComposite: RxCellModelDatasoursable {
  // MARK :- ModelItemDatasoursable
  var diffIdentifier: String? {
    return self.identifier
  }
  
  func strictReload() -> Bool {
    return base.strictReload()
  }
}

extension RowFormBoolComposite: RxCellModelDatasoursable {
  var diffIdentifier: String? {
    return self.identifier
  }
  
  func strictReload() -> Bool {
    return base.strictReload()
  }
}

extension RowCustomComposite: RxCellModelDatasoursable {
  var diffIdentifier: String? {
    return self.identifier
  }
  
  func strictReload() -> Bool {
    return base.strictReload()
  }
}

extension RowFromPhoneComposite: RxCellModelDatasoursable {
  var diffIdentifier: String? {
    return self.identifier
  }
  
  func strictReload() -> Bool {
    return base.strictReload()
  }
}

extension RowFormButtonComposite: RxCellModelDatasoursable {
  // MARK :- ModelItemDatasoursable
  var diffIdentifier: String? {
    return self.identifier
  }
  
  func strictReload() -> Bool {
    return base.strictReload()
  }
}
