//
// Created by Arnon Keereena on 2019-05-03.
//

import Foundation
import RxSwift

public class LoggerPlugin: PluginType {
  public func willSend(httpRequest: HTTPRequest, request: URLRequest) throws -> Single<URLRequest> {
    return Single.just(request)
                 .do(onNext: { print($0) })
  }
  
  public func didSend(request: URLRequest, received response: HTTPResponse) throws -> Single<HTTPResponse> {
    return Single.just(response)
                 .do(onNext: { print($0) })
  }
}
