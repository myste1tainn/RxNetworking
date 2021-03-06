//
// Created by Arnon Keereena on 2019-05-01.
//

import Foundation

public enum AuthorizationType: Hashable {
  case none
  case basic
  case bearer
  case custom(_ value: String)
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine("\(self)")
  }
  
  var value: String {
    switch self {
    case .none: return ""
    case .basic: return "Basic"
    case .bearer: return "Bearer"
    case .custom(let value): return value
    }
  }
}
