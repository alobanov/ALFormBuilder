//
//  Bundle+ALFBAdditions.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 31/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

extension Bundle {
  public static func alfb_frameworkBundle() -> Bundle {
    let bundle = Bundle(for: ALFormBuilder.self)
    if let path = bundle.path(forResource: "ALFormBuilder", ofType: "bundle") {
      return Bundle(path: path)!
    }
    else {
      return bundle
    }
  }
}
