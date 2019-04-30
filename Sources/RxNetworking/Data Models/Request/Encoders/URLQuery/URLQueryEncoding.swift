//
// Created by Arnon Keereena on 2019-04-27.
//

import Foundation

public class URLQueryEncoding: Encoder {
  public internal(set) var codingPath: [CodingKey] = []
  public internal(set) var userInfo: [CodingUserInfoKey: Any] = [:]
  
  var data: Data
  
  init(to encodedData: Data = Data(), codingPath: [CodingKey] = []) {
    self.data = encodedData
    self.codingPath = codingPath
  }
  
  public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
    return .init(KeyedContainer(to: data, codingPath: codingPath))
  }
  
  public func unkeyedContainer() -> UnkeyedEncodingContainer {
    return UnkeyedContainer(to: data, codingPath: codingPath)
  }
  
  public func singleValueContainer() -> SingleValueEncodingContainer {
    return SingleValueContainer(to: data, codingPath: codingPath)
  }
}
