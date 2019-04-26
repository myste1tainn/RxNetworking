//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

public struct HTTPRequest {
  
  public var request: URLRequest {
    let url = target.baseURL.appendingPathComponent(target.path)
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = target.headers
    let method = target.method.rawValue
    request.httpMethod = method
    return request
  }
  
  public var target: TargetType
  
  public init(target: TargetType) {
    self.target = target
  }
  
  public func appending(parameters: Encodable, encoding: Parameter.Encoding) -> URLRequest {
    var request = self.request
    request.httpBody = try! "".data(using: .utf8)
    return request
  }
}
