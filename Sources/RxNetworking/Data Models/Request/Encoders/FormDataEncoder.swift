//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

open class FormDataEncoder {
  let boundary: String
  
  init(boundary: String) {
    self.boundary = boundary
  }
  
  open func encode<T: Encodable>(_ value: T) throws -> Data {
    return try encodeString(value).data(using: .ascii) ?? Data()
  }
  
  func encodeString<T: Encodable>(_ value: T) throws -> String {
    let encoder = StringMapEncoding()
    try value.encode(to: encoder)
    return formDataString(dictionary: encoder.data.maps)
  }
  
  private func formDataString(dictionary: [String: String]) -> String {
    let body = dictionary.sorted { $0.key < $1.key }
                         .map(componentStringWithKeyValueBy(boundary: boundary))
                         .reduce("") { $0 + "\($1)\n" }
                         .dropLast()
    return """
           \(body)
           --\(boundary)--
           """
  }
  
  private func componentStringWithKeyValueBy(boundary: String) -> (String, String) -> String {
    return {
      self.componentString(key: $0, value: $1, boundary: boundary)
    }
  }
  
  private func componentString(key: String, value: String, boundary: String) -> String {
    let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    return """
           --\(boundary)
           Content-Disposition: form-data; name="\(key)"
           
           \(encodedValue)
           """
  }
  
}

