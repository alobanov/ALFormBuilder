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
  case textField = 0, multilineTextField, buttonField, boolField, pickerField, phoneField, staticText
  
  public var type: UITableViewCell.Type {
    switch self {
    case .textField:
      return ALFBTextViewCell.self
    case .multilineTextField:
      return ALFBTextMultilineViewCell.self
    case .buttonField:
      return ALFBButtonViewCell.self
    case .boolField:
      return ALFBBoolViewCell.self
    case .pickerField:
      return ALFBPickerViewCell.self
    case .phoneField:
      return ALFBPhoneViewCell.self
    case .staticText:
      return ALFBStaticTextViewCell.self
    }
  }
}
