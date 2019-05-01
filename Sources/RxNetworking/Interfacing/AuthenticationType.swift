//
// Created by Arnon Keereena on 2019-05-01.
//

import Foundation

public enum AuthenticationType {
  case basic
  case bearer
  case custom(_ value: String)
  
  var value: String {
    switch self {
    case .basic: return "Basic"
    case .bearer: return "Bearer"
    case .custom(let value): return value
    }
  }
}
