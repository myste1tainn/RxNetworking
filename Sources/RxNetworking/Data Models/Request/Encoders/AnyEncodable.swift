//
// Created by Arnon Keereena on 2019-04-30.
//

import Foundation

public struct AnyEncodable: Encodable {
  let encodable: Encodable
  
  public init(_ encodable: Encodable) {
    self.encodable = encodable
  }
  
  public func encode(to encoder: Encoder) throws {
    try encodable.encode(to: encoder)
  }
}
