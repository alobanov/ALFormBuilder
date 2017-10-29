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
  case editField, buttonField, boolField, pickerField
  
  var type: UITableViewCell.Type {
    switch self {
    case .editField:
      return FormTextViewCell.self
    case .buttonField:
      return FormButtonViewCell.self
    case .boolField:
      return FormBoolViewCell.self
    case .pickerField:
      return FormPickerViewCell.self
    }
  }
}

enum FormCustomCells: UniversalCellProtocol {
  case customField
  
  var type: UITableViewCell.Type {
    switch self {
    case .customField:
      return FormTextInfoViewCell.self
    }
  }
}
