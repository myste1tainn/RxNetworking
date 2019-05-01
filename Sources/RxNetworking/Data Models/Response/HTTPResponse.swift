//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

public struct HTTPResponse {
  public var statusCode: Int { return httpURLResponse.statusCode }
  public var data: Data
  public var httpURLResponse: HTTPURLResponse
  
  public init(httpURLResponse: HTTPURLResponse, data: Data) {
    self.httpURLResponse = httpURLResponse
    self.data = data
  }
  
  public func map<T: Decodable>(_ type: T.Type) throws -> T {
    let decoder = JSONDecoder()
    let result = try decoder.decode(type, from: data)
    return result
  }
}
