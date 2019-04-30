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
    let anyEncodable = AnyEncodable(parameters)
    switch encoding {
    case .query:
      let query = try? URLQueryEncoder().encode(anyEncodable)
      let newString = (request.url?.absoluteString ?? "") + (query ?? "")
      let newUrl = URL(string: newString)!
      request.url = newUrl
    case .body(let type):
      switch type {
      case .json:
        let body = try? JSONEncoder().encode(anyEncodable)
        if request.allHTTPHeaderFields == nil {
          request.allHTTPHeaderFields = [:]
        }
        request.allHTTPHeaderFields?["Content-Type"] = type.value
        request.httpBody = body
      default:
        return request
      }
    }
    return request
  }
}
