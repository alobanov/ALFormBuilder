//
//  CellsEnum.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit.UITableViewCell

public enum ALFBCells: Int, FBUniversalCellProtocol {
  case editField = 0, buttonField, boolField, pickerField, phoneField
  
  public var type: UITableViewCell.Type {
    switch self {
    case .editField:
      return ALFBTextViewCell.self
    case .buttonField:
      return ALFBButtonViewCell.self
    case .boolField:
      return ALFBBoolViewCell.self
    case .pickerField:
      return ALFBPickerViewCell.self
    case .phoneField:
      return ALFBPhoneViewCell.self
    }
  }
}

public enum FormCustomCells: Int, FBUniversalCellProtocol {
  case customField
  
  public var type: UITableViewCell.Type {
    switch self {
    case .customField:
      return ALFBTextInfoViewCell.self
    }
  }
}
