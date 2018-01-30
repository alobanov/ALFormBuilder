//
//  UITextField+TypeFilter.swift
//  Pulse
//
//  Created by Aleksey Lobanov on 11.08.16.
//  Copyright © 2016 Aleksey Lobanov All rights reserved.
//

import UIKit

public struct UITextFieldFilterOptions : OptionSet {
  let rawValue: Int
  
  static let None         = UITextFieldFilterOptions(rawValue: 0)
  static let RemoveWhitespacesOption  = UITextFieldFilterOptions(rawValue: 1 << 0)
  static let OnlyNumbersOption  = UITextFieldFilterOptions(rawValue: 1 << 1)
  static let OnlyDecimalOption  = UITextFieldFilterOptions(rawValue: 1 << 2)
  static let PhoneNumberOption  = UITextFieldFilterOptions(rawValue: 1 << 3)
  static let CellularPhoneNumberOption  = UITextFieldFilterOptions(rawValue: 1 << 4)
}

public extension UITextField {
  
  static let decimalSeparators = [",", "."]
  
  public func filtred(_ options: UITextFieldFilterOptions, string: String = "", range: NSRange = NSRange(),
               maxLeng: Int? = nil, maxFractionDigits: Int = 0) -> Bool {
    
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
      if !self.filterdOnlyDecimal(range: range, string: string) {
        return false
      }
      if maxFractionDigits > 0,
        !self.filtredFractionDigits(maxFractionDigits, range: range, string: string)
      {
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
  
  private func filtredFractionDigits(_ limit: Int, range: NSRange, string: String) -> Bool {
    let text = self.text ?? ""
    let oldStyleText: NSString = text as NSString
    var updatedText = oldStyleText.replacingCharacters(in: range, with: string)
    var componets: [String] = []
    for separator in UITextField.decimalSeparators {
      componets = updatedText.components(separatedBy: separator)
      if componets.count > 1 {
        break
      }
    }
    let hasFraction = componets.count > 1
    let fractionIsInLimit = hasFraction && componets[1].count <= limit
    if fractionIsInLimit {
      return true
    } else if hasFraction {
      if let selectedRange = self.selectedTextRange {
        var indexToRemove = updatedText.index(updatedText.endIndex, offsetBy: -1)
        if range.location + 1 < updatedText.count {
          indexToRemove = updatedText.index(updatedText.startIndex, offsetBy: range.location+1)
        }
        updatedText.remove(at: indexToRemove)
        self.text = updatedText
        if let newPosition = self.position(from: selectedRange.start, offset: 1) {
          self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
      }
      return false
    }
    return true
  }
  
  private func filtredOnlyNumbers(_ string: String) -> Bool {
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacters.isSuperset(of: characterSet)
  }
  
  private func filterdOnlyDecimal(range: NSRange, string: String) -> Bool {
    let oldText = self.text ?? ""
    
    for separator in UITextField.decimalSeparators {
      if string == separator && oldText.count == 0 {
        return false
      }
    }
    
    if (oldText == "0" && !UITextField.decimalSeparators.contains(string) && string != "") {
      return false
    }
    
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    let boolIsNumber = allowedCharacters.isSuperset(of: characterSet)
    
    if boolIsNumber == true {
      return true
    } else {
      var oldTextContainsNoSeparators = true
      for separator in UITextField.decimalSeparators {
        if oldText.contains(separator) {
          oldTextContainsNoSeparators = false
          break
        }
      }
      if oldTextContainsNoSeparators {
        var stringContainsSingleSeparator = true
        var stringSeparator: String?
        for separator in UITextField.decimalSeparators {
          if string.contains(separator) {
            if stringSeparator != nil {
              stringContainsSingleSeparator = false
            }
            stringSeparator = separator
          }
        }
        return stringSeparator != nil && stringContainsSingleSeparator ? true : false
      } else {
        return false
      }
      //---------
//      if string == "." {
//        let countdots = oldText.components(separatedBy: ".").count-1
//        if countdots == 0 {
//          return true
//        } else {
//          if countdots > 0 && string == "." {
//            return false
//          } else {
//            return true
//          }
//        }
//      } else {
//        return false
//      }
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

