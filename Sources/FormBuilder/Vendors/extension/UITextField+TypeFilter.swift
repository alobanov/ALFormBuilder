//
//  UITextField+TypeFilter.swift
//  Pulse
//
//  Created by MOPC on 11.08.16.
//  Copyright © 2016 MOPC Lab. All rights reserved.
//

import UIKit

struct UITextFieldFilterOptions : OptionSet {
  let rawValue: Int
  
  static let None         = UITextFieldFilterOptions(rawValue: 0)
  static let RemoveWhitespacesOption  = UITextFieldFilterOptions(rawValue: 1 << 0)
  static let OnlyNumbersOption  = UITextFieldFilterOptions(rawValue: 1 << 1)
  static let OnlyDecimalOption  = UITextFieldFilterOptions(rawValue: 1 << 2)
  static let PhoneNumberOption  = UITextFieldFilterOptions(rawValue: 1 << 3)
  static let CellularPhoneNumberOption  = UITextFieldFilterOptions(rawValue: 1 << 4)
}

extension UITextField {
  func filtred(_ options: UITextFieldFilterOptions, string: String = "", range: NSRange = NSRange(), maxLeng: Int? = nil) -> Bool {
    
    if options.contains(.RemoveWhitespacesOption) {
      if !self.filtredWhitespace(string) {
        return false
      }
    }
    
    if let length = maxLeng {
      if !self.filtredLimitLength(length, range: range, string: string) {
        return false
      }
    }
    
    if options.contains(.OnlyNumbersOption) {
      if !self.filtredOnlyNumbers(string) {
        return false
      }
    }
    
    if options.contains(.OnlyDecimalOption) {
      if !self.filterdOnlyDecimal(string) {
        return false
      }
    }
    
    if options.contains(.PhoneNumberOption) {
      if !self.filterdPhoneNumber(string) {
        return false
      }
    }
    
    if options.contains(.CellularPhoneNumberOption) {
      if !self.filterdCellularPhoneNumber(string) {
        return false
      }
    }
    
    return true
  }
  
  private func filtredWhitespace(_ string: String) -> Bool {
    let whitespaceSet = CharacterSet.whitespacesAndNewlines
    let range = string.rangeOfCharacter(from: whitespaceSet)
    return range != nil ? false : true
  }
  
  private func filtredLimitLength(_ limitLength: Int, range: NSRange, string: String) -> Bool {
    guard let text = self.text else { return true }
    let newLength = text.utf16.count + string.utf16.count - range.length
    return newLength <= limitLength // Bool
  }
  
  private func filtredOnlyNumbers(_ string: String) -> Bool {
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacters.isSuperset(of: characterSet)
  }
  
  private func filterdOnlyDecimal(_ string: String) -> Bool {
    let s = self.text!
    let countOldChar = s.count
    
    if string.contains(",") {
//    if string.contains(find: ",") {
      return false
    }
    
    if (string == "." && countOldChar == 0) {
      return false
    }
    
    if (s == "0" && (string != "." && string != "")) {
      return false
    }
    
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    let boolIsNumber = allowedCharacters.isSuperset(of: characterSet)
    
    if boolIsNumber == true {
      return true
    } else {
      if string == "." {
        let countdots = s.components(separatedBy: ".").count-1
        if countdots == 0 {
          return true
        } else {
          if countdots > 0 && string == "." {
            return false
          } else {
            return true
          }
        }
      } else {
        return false
      }
    }
  }
  
  private func filterdPhoneNumber(_ string: String) -> Bool {
    let allowedCharacters = CharacterSet(charactersIn: "0123456789+#*,;")
    return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
  }
  
  private func filterdCellularPhoneNumber(_ string: String) -> Bool {
    let allowedCharacters = CharacterSet(charactersIn: "0123456789+")
    return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
  }
  
}

