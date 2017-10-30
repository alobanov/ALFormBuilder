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
  public var diffIdentifier: String? {
    return self.identifier
  }
  
  public func strictReload() -> Bool {
    return base.strictReload()
  }
}

extension RowFormBoolComposite: RxCellModelDatasoursable {
  public var diffIdentifier: String? {
    return self.identifier
  }
  
  public func strictReload() -> Bool {
    return base.strictReload()
  }
}

extension RowCustomComposite: RxCellModelDatasoursable {
  public var diffIdentifier: String? {
    return self.identifier
  }
  
  public func strictReload() -> Bool {
    return base.strictReload()
  }
}

extension RowFromPhoneComposite: RxCellModelDatasoursable {
  public var diffIdentifier: String? {
    return self.identifier
  }
  
  public func strictReload() -> Bool {
    return base.strictReload()
  }
}

extension RowFormButtonComposite: RxCellModelDatasoursable {
  // MARK :- ModelItemDatasoursable
  public var diffIdentifier: String? {
    return self.identifier
  }
  
  public func strictReload() -> Bool {
    return base.strictReload()
  }
}
