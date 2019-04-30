//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

public enum Task {
  case plain
  case parametered(with: Encodable, encoding: Parameter.Encoding)
}

