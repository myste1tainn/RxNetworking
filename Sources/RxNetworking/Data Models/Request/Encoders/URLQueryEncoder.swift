//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

open class URLQueryEncoder {
  open func encode<T: Encodable>(_ value: T) throws -> Data {
    return try encodeString(value).data(using: .ascii) ?? Data()
  }
  
  open func encodeString<T: Encodable>(_ value: T) throws -> String {
    let encoder = StringMapEncoding()
    try value.encode(to: encoder)
    return queryString(dictionary: encoder.data.maps)
  }
  
  private func queryString(dictionary: [String: String]) -> String {
    let string = dictionary.sorted { $0.key < $1.key }
                           .map(queryStringComponent(key:value:))
                           .reduce("?") { $0 + "\($1)&" }
                           .dropLast()
    return String(string)
  }
  
  private func queryStringComponent(key: String, value: String) -> String {
    return "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
  }
  
}

