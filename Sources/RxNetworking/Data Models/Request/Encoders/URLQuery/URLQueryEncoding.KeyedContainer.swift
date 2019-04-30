//
// Created by Arnon Keereena on 2019-04-27.
//

import Foundation

extension URLQueryEncoding {
  public struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    public internal(set) var codingPath: [CodingKey] = []
    
    private let data: URLQueryEncoding.Data
    
    init(to data: URLQueryEncoding.Data, codingPath: [CodingKey] = []) {
      self.data = data
      self.codingPath = codingPath
    }
    
    public func encodeNil(forKey key: Key) throws {
      return data.encode(key: key, value: "")
    }
    
    public func encode(_ value: Bool, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: String, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: Double, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: Float, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: Int, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: Int8, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: Int16, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: Int32, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: Int64, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: UInt, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: UInt8, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: UInt16, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: UInt32, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode(_ value: UInt64, forKey key: Key) throws {
      return data.encode(key: key, value: value.description)
    }
    
    public func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
      let encoding = URLQueryEncoding(to: data)
      encoding.codingPath.append(key)
      try value.encode(to: encoding)
      
    }
    
    public func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
      return .init(KeyedContainer<NestedKey>(to: data, codingPath: [key]))
    }
    
    public func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
      return UnkeyedContainer(to: data, codingPath: [key])
    }
    
    public func superEncoder() -> Encoder {
      let superKey = Key(stringValue: "super")!
      return superEncoder(forKey: superKey)
    }
    
    public func superEncoder(forKey key: Key) -> Encoder {
      return URLQueryEncoding(to: data, codingPath: codingPath + [key])
    }
  }
}
