//
//  CellIdentifiable.swift
//  Pulse
//
//  Created by Aleksey Lobanov on 09.10.16.
//  Copyright © 2016 Aleksey Lobanov All rights reserved.
//

import UIKit

protocol CellIdentifiable {
  static var cellIdentifier: String { get }
}

extension CellIdentifiable where Self: UITableViewCell {
  static var cellIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: CellIdentifiable {}

extension UITableView {
  func dequeueReusableTableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath, andtype:T.Type) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: andtype.cellIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.cellIdentifier)")
    }
    
    return cell
  }
}
