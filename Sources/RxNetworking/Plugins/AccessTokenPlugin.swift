//
// Created by Arnon Keereena on 2019-05-03.
//

import Foundation
import RxSwift

/// Plugin to provide access token to request before it will be sent out to internet
/// Uses single stream of token string as parameter
public class AccessTokenPlugin: PluginType {
  
  let tokenSingle: Single<String>
  
  public init(tokenSingle: Single<String>) {
    self.tokenSingle = tokenSingle
  }
  
  // MARK: - PluginType
  
  public func willSend(httpRequest: HTTPRequest, request: URLRequest) throws -> Single<URLRequest> {
    guard let tuple = authHeaderTuple(httpRequest: httpRequest, request: request) else {
      return .just(request)
    }
    return tokenSingle.map {
      var request = request
      request.allHTTPHeaderFields?[tuple.key] = tuple.value + $0
      return request
    }
  }
  
  public func didSend(request: URLRequest, received response: HTTPResponse) throws -> Single<HTTPResponse> {
    return .just(response)
  }
  
  // MARK: - helper functions
  
  private func authHeaderTuple(httpRequest: HTTPRequest, request: URLRequest) -> (key: String, value: String)? {
    guard let target = httpRequest.target as? AccessTokenAuthorizable,
          let tuple = request.allHTTPHeaderFields?.first(where: { $0.key == target.authenticationHeader }) else {
      return nil
    }
    return tuple
  }
}
