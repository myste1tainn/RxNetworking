//
// Created by Arnon Keereena on 2019-05-03.
//

import Foundation
import RxSwift

public class LoggerPlugin: PluginType {
  public func willSend(httpRequest: HTTPRequest, request: URLRequest) throws -> Single<URLRequest> {
    return Single.just(request)
                 .do(onSuccess: { print($0.curlString) })
  }
  
  public func didSend(request: URLRequest, received response: HTTPResponse) throws -> Single<HTTPResponse> {
    return Single.just(response)
                 .do(onSuccess: { print($0) })
  }
}

extension URLRequest {
  public var curlString: String {
    let data = self.httpBody ?? Data()
    let headers = self.allHTTPHeaderFields?.enumerated().reduce("") {
      let base = "-H '\($1.element.key): \($1.element.value)'"
      return $1.offset == 0 ? base : "\($0 ?? "") \\\n     \(base)"
    } ?? ""
    let body = String(data: data, encoding: .ascii) ?? String(data: data, encoding: .utf8) ?? ""
    
    return """
           curl -X \(self.httpMethod ?? "") \\
                \(headers) \\
                -d '\(body)' \\
                '\(self.url?.absoluteString ?? "")' -vs
           """
  }
}

