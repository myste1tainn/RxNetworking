//
// Created by Arnon Keereena on 2019-04-27.
//

import Foundation

extension StringMapEncoding {
  public struct SingleValueContainer: SingleValueEncodingContainer {
    
    private let data: StringMapEncoding.Data
    
    init(to data: StringMapEncoding.Data, codingPath: [CodingKey]) {
      self.data = data
      self.codingPath = codingPath
    }
    
    public var codingPath: [CodingKey] = []
    
    public mutating func encodeNil() throws {
      data.encode(keys: codingPath, value: "nil")
    }
    
    public mutating func encode(_ value: Bool) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: String) throws {
      data.encode(keys: codingPath, value: value)
    }
    
    public mutating func encode(_ value: Double) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: Float) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: Int) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: Int8) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: Int16) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: Int32) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: Int64) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: UInt) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: UInt8) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: UInt16) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: UInt32) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode(_ value: UInt64) throws {
      data.encode(keys: codingPath, value: value.description)
    }
    
    public mutating func encode<T: Encodable>(_ value: T) throws {
      let encoding = StringMapEncoding(to: data)
      encoding.codingPath = codingPath
      try value.encode(to: encoding)
    }
  }

}
