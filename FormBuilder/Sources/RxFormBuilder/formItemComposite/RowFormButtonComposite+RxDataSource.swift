//
//  RowFormButtonComposite+RxDataSource.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

extension RowFormButtonComposite: RxCellModelDatasoursable {
  // MARK :- ModelItemDatasoursable
  var diffIdentifier: String? {
    return self.identifier
  }
  
  func strictReload() -> Bool {
    return base.strictReload()
  }
}
