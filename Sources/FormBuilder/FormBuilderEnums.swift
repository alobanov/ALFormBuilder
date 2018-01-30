//
//  FormBuilderEnums.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit

public extension ALFB {
  public enum Cells: Int, FBUniversalCellProtocol {
    case emptyField
    
    public var type: UITableViewCell.Type {
      switch self {
      case .emptyField:
        return UITableViewCell.self
      }
    }
  }
  
  public enum FBKeyboardType: Int {
    case defaultKeyboard = 0 // Default type for the current input method.
    case numbersAndPunctuation = 1 // Numbers and assorted punctuation.
    case URL = 2 // A type optimized for URL entry (shows . / .com prominently).
    case numberPad = 3 // A number pad with locale-appropriate digits
    case phonePad = 4 // A phone pad (1-9, *, 0, #, with letters under the numbers).
    case namePhonePad = 5 // A type optimized for entering a person's name or phone number.
    case emailAddress = 6// A type optimized for multiple email
    case decimalPad = 7// A number pad with a decimal point.
    
    public var keyboardType: UIKeyboardType {
      switch self {
      case .defaultKeyboard: return .default
      case .numbersAndPunctuation: return .numbersAndPunctuation
      case .URL: return .URL
      case .numberPad: return .numberPad
      case .phonePad: return .phonePad
      case .namePhonePad: return .namePhonePad
      case .emailAddress: return .emailAddress
      case .decimalPad: return .decimalPad
      }
    }
  }
  
  public enum FBAutocapitalizationType: Int {
    case none, sentences, words, allCharacters
    
    public var autocapitalizationType: UITextAutocapitalizationType {
      switch self {
      case .none: return .none
      case .words: return .words
      case .sentences: return .sentences
      case .allCharacters: return .allCharacters
      }
    }
  }
  
  public enum FormModelLevel {
    case root
    case section
    case item
  }
  
  public enum DataType: Int {
    /// Строка
    case string =  0
    case integer = 1
    case decimal = 2
    case bool = 3
    case date = 4
    case list = 5
    case phonenumber = 6
    case password = 7
    case button = 8
    case informationContent = 9
    case avatarSelection = 10
    case radio = 11
    case picker = 12
  }
  
  public enum ValidationType {
    case none
    case nonNil
    case regexp(String)
    case phone
    case closure(ALFBClosureValidation)
  }
  
  public enum ValidationState {
    case valid
    case failed(message: String)
    case typing
  }
}

public func == (lhs: ALFB.ValidationState, rhs: ALFB.ValidationState) -> Bool {
  switch (lhs, rhs) {
  case (.valid, .valid):
    return true
  case (.failed, .failed):
    return true
  case (.typing, .typing):
    return true
  default:
    return false
  }
}

public func == (lhs: ALFB.FormModelLevel, rhs: ALFB.FormModelLevel) -> Bool {
  switch (lhs, rhs) {
  case (.root, .root):
    return true
  case (.section, .section):
    return true
  case (.item, .item):
    return true
  default:
    return false
  }
}

public extension ALFB.ValidationState {
  public var isValidWithTyping: Bool {
    switch self {
    case .valid, .typing:
      return true
    default:
      return false
    }
  }
  
  public var isCompletelyValid: Bool {
    switch self {
    case .valid:
      return true
    default:
      return false
    }
  }
  
  public var isVisibleValidationUI: Bool {
    if !self.isCompletelyValid {
      switch self {
      case .typing:
        return false
      default:
        return true
      }
    } else {
      return false
    }
  }
  
  public var color: UIColor {
    switch self {
    case .valid:
      return ALFBStyle.fbSuccess
    case .failed:
      return ALFBStyle.fbFailure
    case .typing:
      return ALFBStyle.fbLightGray
    }
  }
  
  public var message: String {
    switch self {
    case let .failed(message):
      return message
    default:
      return ""
    }
  }
}
