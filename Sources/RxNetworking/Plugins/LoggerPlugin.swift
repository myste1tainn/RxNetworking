//
// Created by Arnon Keereena on 2019-05-03.
//

import Foundation
import RxSwift

public class LoggerPlugin: PluginType {
  public func willSend(httpRequest: HTTPRequest, request: URLRequest) throws -> Single<URLRequest> {
    return Single.just(request)
                 .do(onNext: { print($0.description) })
  }
  
  public func didSend(request: URLRequest, received response: HTTPResponse) throws -> Single<HTTPResponse> {
    return Single.just(response)
                 .do(onNext: { print($0) })
  }
}

extension URLRequest: CustomStringConvertible {
  public var description: String {
    let data = self.httpBody ?? Data()
    let headers = self.allHTTPHeaderFields?.enumerated().reduce("") {
      let base = "-H '\($1.element.key): \($1.element.value)'"
      return $1.offset == 0 ? base : "\($0 ?? "") \\\n     \(base)"
    } ?? ""
    let body = String(data: data, encoding: .ascii) ?? String(data: data, encoding: .utf8) ?? ""
    
    return """
           curl -X \(self.httpMethod ?? "") \\
                -d '\(body)' \\
                \(headers) \\
                '\(self.url?.absoluteString ?? "")' -vs
           
           """
  }
}

