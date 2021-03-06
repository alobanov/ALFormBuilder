//
//  UITableView+Additions.swift
//  Pulse
//
//  Created by Aleksey Lobanov on 10.10.16.
//  Copyright © 2016 Aleksey Lobanov All rights reserved.
//

import UIKit

extension UITableView {

  func setupEstimatedRowHeight(height: CGFloat? = nil) {
    // configure table view
    self.rowHeight = UITableViewAutomaticDimension
    self.estimatedRowHeight = height ?? 60.0
  }

  func setupEstimatedFooterHeight() {
    self.estimatedSectionFooterHeight = UITableViewAutomaticDimension
    self.estimatedSectionFooterHeight = 25.0
  }

  func setupEstimatedHeaderHeight() {
    estimatedSectionHeaderHeight = UITableViewAutomaticDimension
    estimatedSectionHeaderHeight = 40.0
  }

  func registerCell(by identifier: String) {
    register(UINib(nibName: identifier, bundle: nil),
         forCellReuseIdentifier: identifier)
  }
  
  func registerCells(by identifiers: [String], bundle: Bundle? = nil) {
    for identifier in identifiers {
      register(UINib(nibName: identifier, bundle: bundle),
               forCellReuseIdentifier: identifier)
    }
  }

}
