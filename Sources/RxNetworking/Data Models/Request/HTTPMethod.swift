//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

public enum HTTPMethod: String {
  case get     = "GET"
  case post    = "POST"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
  case head    = "HEAD"
  case options = "OPTIONS"
  case connect = "CONNECT"
  case trace   = "TRACE"
}
