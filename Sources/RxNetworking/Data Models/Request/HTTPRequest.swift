//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

public struct HTTPRequest {
  
  public var urlRequest: URLRequest {
    let url     = target.baseURL.appendingPathComponent(target.path)
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = target.headers
    request.httpMethod = target.method.rawValue
    request = appending(to: request, byTask: target.task)
    if let authorizable = target as? AccessTokenAuthorizable {
      request = appending(to: request, byAuthorizable: authorizable)
    }
    return request
  }
  
  public var target: TargetType
  
  public init(target: TargetType) {
    self.target = target
  }
  
  private func ensureHeadersProperty(to request: URLRequest) -> URLRequest {
    if request.allHTTPHeaderFields == nil {
      var request = request
      request.allHTTPHeaderFields = [:]
      return request
    } else {
      return request
    }
  }
  
  public func appending(to request: URLRequest, byAuthorizable target: AccessTokenAuthorizable) -> URLRequest {
    guard target.authorizationType != .none else { return request }
    
    let headerKey         = target.authorizationHeader
    let prefix            = target.authorizationType.value
    let headerValuePrefix = prefix.isEmpty ? prefix : prefix + " "
    
    var request = ensureHeadersProperty(to: request)
    request.allHTTPHeaderFields?[headerKey] = "\(headerValuePrefix)"
    return request
  }
  
  public func appending(to request: URLRequest, byTask task: Task) -> URLRequest {
    switch task {
    case .plain: return request
    case .parametered(let parameters, let encoding): return appending(parameters: parameters,
                                                                      encoding: encoding,
                                                                      to: request)
    }
  }
  
  public func appending(parameters: Encodable,
                        encoding: Parameter.Encoding,
                        to request: URLRequest) -> URLRequest {
    var request      = request
    let anyEncodable = AnyEncodable(parameters)
    switch encoding {
    case .query:
      let query     = try? URLQueryEncoder().encodeString(anyEncodable)
      let newString = (request.url?.absoluteString ?? "") + (query ?? "")
      let newUrl    = URL(string: newString)!
      request.url = newUrl
    case .body(let type):
      request.set(key: "Content-Type", value: type.value)
      switch type {
      case .json: request.httpBody = try? JSONEncoder().encode(anyEncodable)
      case .form(let subtype):
        switch subtype {
        case .urlEncoded: request.httpBody = try? URLQueryEncoder().encode(anyEncodable)
        case .data:
          guard let boundary = subtype.boundary,
                let headerValue = request.allHTTPHeaderFields?["Content-Type"] else {
            return request
          }
          request.allHTTPHeaderFields?["Content-Type"] = "\(headerValue); boundary=\(boundary)"
          request.httpBody = try? FormDataEncoder(boundary: boundary).encode(anyEncodable)
        }
      default: return request
      }
    }
    return request
  }
}


extension URLRequest {
  mutating func set(key: String, value: String) {
    if allHTTPHeaderFields == nil {
      allHTTPHeaderFields = [:]
    }
    allHTTPHeaderFields?[key] = value
  }
}
