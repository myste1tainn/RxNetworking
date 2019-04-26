//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

public struct Parameter {
  public enum Encoding {
    case query
    case body(contentType: HTTPContentType)
  }
}
