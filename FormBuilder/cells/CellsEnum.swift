//
//  CellsEnum.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit.UITableViewCell

enum FormBuilderCells: UniversalCellProtocol {
  case editField, buttonField, boolField
  
  var type: UITableViewCell.Type {
    switch self {
    case .editField:
      return FormTextViewCell.self
    case .buttonField:
      return FormButtonViewCell.self
    case .boolField:
      return FormBoolViewCell.self
    }
  }
}
