import UIKit

public extension String {
//  func contains(find: String) -> Bool {
//    return self.range(of: find) != nil
//  }
  
  public static let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.decimalSeparator = "."
    return numberFormatter
  }()
  
  public func replace(string:String, replacement:String) -> String {
    return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
  }
  
  public func trim() -> String {
    return self.trimmingCharacters(in: CharacterSet.whitespaces)
  }
  
  public func removeAllWhitespace() -> String {
    return self.replace(string: " ", replacement: "")
  }
  
  public var strToInt: Int? {
    return String.numberFormatter.number(from: self)?.intValue
  }
  
  public var strToFloat: Float? {
    return String.numberFormatter.number(from: self)?.floatValue
  }
  
  public func strToBool() -> Bool {
    switch self {
    case "1": return true
    case "true": return true
    default: return false
    }
  }
  
  public var capitalizeFirst: String {
    if isEmpty { return "" }
    var result = self
    result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).uppercased())
    return result
  }
  
  public var lowercaseFirst: String {
    if isEmpty { return "" }
    var result = self
    result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
    return result
  }
  
  public subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
  
  public subscript (i: Int) -> String {
    if self.isEmpty {
      return ""
    } else {
      return String(self[i] as Character)
    }
  }
  
  public subscript (r: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(startIndex, offsetBy: r.upperBound)
    return String(self[Range(start ..< end)])
  }
}
