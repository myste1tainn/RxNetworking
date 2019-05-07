//
// Created by Arnon Keereena on 2019-04-27.
//

import Foundation

extension StringMapEncoding {
  public struct UnkeyedContainer: UnkeyedEncodingContainer {
    private let data: StringMapEncoding.Data
    
    public var codingPath: [CodingKey] = []
    
    public var count: Int = 0
    
    init(to data: StringMapEncoding.Data, codingPath: [CodingKey] = []) {
      self.data = data
      self.codingPath = codingPath
    }
    
    private mutating func nextIndexedKey() -> CodingKey {
      let nextCodingKey = IndexedCodingKey(intValue: count)!
      count += 1
      return nextCodingKey
    }
    
    private struct IndexedCodingKey: CodingKey {
      let intValue: Int?
      let stringValue: String
      
      init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = intValue.description
      }
      
      init?(stringValue: String) {
        return nil
      }
    }
    
    public mutating func encodeNil() throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: "nil")
    }
    
    public mutating func encode(_ value: Bool) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: String) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value)
    }
    
    public mutating func encode(_ value: Double) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: Float) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: Int) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: Int8) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: Int16) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: Int32) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: Int64) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: UInt) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: UInt8) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: UInt16) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: UInt32) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode(_ value: UInt64) throws {
      data.encode(keys: codingPath + [nextIndexedKey()], value: value.description)
    }
    
    public mutating func encode<T: Encodable>(_ value: T) throws {
      let encoder = StringMapEncoding(to: data, codingPath: codingPath + [nextIndexedKey()])
      try value.encode(to: encoder)
    }
    
    public mutating func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
      return .init(KeyedContainer<NestedKey>(to: data, codingPath: codingPath + [nextIndexedKey()]))
    }
    
    public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
      return UnkeyedContainer(to: data, codingPath: codingPath + [nextIndexedKey()])
    }
    
    public mutating func superEncoder() -> Encoder {
      let encoding = StringMapEncoding(to: data)
      encoding.codingPath.append(nextIndexedKey())
      return encoding
    }
  }
}
