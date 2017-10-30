import UIKit

extension String {
  func contains(find: String) -> Bool {
    return self.range(of: find) != nil
  }
  
  func replace(string:String, replacement:String) -> String {
    return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
  }
  
  func trim() -> String {
    return self.trimmingCharacters(in: CharacterSet.whitespaces)
  }
  
  func removeAllWhitespace() -> String {
    return self.replace(string: " ", replacement: "")
  }
  
  var strToInt: Int? {
    return NumberFormatter().number(from: self)?.intValue
  }
  
  func strToBool() -> Bool {
    switch self {
    case "1": return true
    case "true": return true
    default: return false
    }
  }
  
  var capitalizeFirst: String {
    if isEmpty { return "" }
    var result = self
    result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).uppercased())
    return result
  }
  
  var lowercaseFirst: String {
    if isEmpty { return "" }
    var result = self
    result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
    return result
  }
  
  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
  
  subscript (i: Int) -> String {
    if self.characters.isEmpty {
      return ""
    } else {
      return String(self[i] as Character)
    }
  }
  
  subscript (r: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(startIndex, offsetBy: r.upperBound)
    return String(self[Range(start ..< end)])
  }
}