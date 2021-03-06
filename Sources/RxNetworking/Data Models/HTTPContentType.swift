//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

public enum HTTPContentType {
  case text(_ subtype: SubType)
  case json
  case javascript
  case xml(_ subtype: SubType)
  case html
  case form(_ subtype: FormSubType)
  
  private var name: String {
    switch self {
    case .text: return "text"
    case .json: return "json"
    case .javascript: return "javascript"
    case .xml: return "xml"
    case .html: return "html"
    case .form: return "x-www-form-urlencoded"
    }
  }
  
  var value: String {
    switch self {
    case .text(let type): return "\(type.rawValue)/\(self.name)"
    case .xml(let type): return "\(type.rawValue)/\(self.name)"
    case .json, .javascript: return "application/\(self.name)"
    case .html: return "text/\(self.name)"
    case .form(let type):
      switch type {
      case .data: return "multipart/\(type.rawValue)"
      case .urlEncoded: return "application/\(type.rawValue)"
      }
    }
  }
  
  public enum SubType: String {
    case text        = "text"
    case application = "application"
  }
  
  public enum FormSubType: String {
    case urlEncoded = "x-www-form-urlencoded"
    case data       = "form-data"
    
    var boundary: String? {
      switch self {
      case .data:
        let uuidString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        return "rxnetworking.boundary.\(uuidString)"
      default: return nil
      }
    }
  }
}
