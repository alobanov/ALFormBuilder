//
//  Dictionary+Ext.swift
//  Pulse
//
//  Created by Aleksey Lobanov on 19.04.17.
//  Copyright © 2017 Aleksey Lobanov All rights reserved.
//

import Foundation
import SwiftyJSON

extension Dictionary {
  func setOrUpdate(value: Any, path: String) -> [String: Any] {
    let keys = path.components(separatedBy: ".")
    var json = JSON(self)

    var keyStack: [String] = []
    var deep = 1

    for key in keys {
      keyStack.append(key)

      if deep == keys.count {
        json[keyStack] = JSON(value)
      } else {
        if json[keyStack].dictionary == nil {
          json[keyStack] = JSON([keys[deep]: ""])
        }
      }

      deep+=1
    }

    return json.dictionaryObject!
  }

  func value(by path: String) -> Any? {
    let keys = path.components(separatedBy: ".")

    let count = keys.count
    var deep = 1

    guard var currentNode = self as? [String: Any] else {
      return nil
    }

    for key in keys {
      if deep == count {

        if (currentNode[key] as? NSNull) != nil {
          return nil
        }

        if let array = currentNode[key] as? [[String: Any]] {
          return array
        }

        if let dict = currentNode[key] as? [String: Any] {
          return dict
        }

        if let result = currentNode[key] {
          let result = String(describing: result)
          return result
        } else {
          return nil
        }
      } else {
        if let nextNode = currentNode[key] as? [String: Any] {
          currentNode = nextNode
        }
      }
      deep+=1
    }

    return nil
  }

  func find<T>(by path: [JSONSubscriptType]) throws -> T {
    let json = JSON(self)
    if let d = json[path].object as? T {
      return d
    } else {
      let d = [NSLocalizedDescriptionKey: "Resources.Data.\(path) is empty or is not an Object"]
      throw NSError(domain: "ru.alobanov", code: 1, userInfo: d)
    }
  }
  
  func nullKeyRemoval() -> [AnyHashable: Any] {
    var dict: [AnyHashable: Any] = self
    
    let keysToRemove = dict.keys.filter { dict[$0] is NSNull }
    let keysToCheck = dict.keys.filter({ dict[$0] is Dictionary })
    for key in keysToRemove {
      dict.removeValue(forKey: key)
    }
    for key in keysToCheck {
      if let valueDict = dict[key] as? [AnyHashable: Any] {
        dict.updateValue(valueDict.nullKeyRemoval(), forKey: key)
      }
    }
    return dict
  }
}

