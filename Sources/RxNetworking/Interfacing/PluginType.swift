//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation
import RxSwift

public protocol PluginType {
  /// Conformers will have a chanage to modify url request just before
  /// client sends it out, http request & url request is sends as parameter
  func willSend(httpRequest: HTTPRequest, request: URLRequest) throws -> Single<URLRequest>
  
  /// Will be called after the request has been sent and response has been received
  /// Conformers can intercept response before it will be "next" to subscriber,
  /// then he/she can choose to throw an error out to make the stream ended up in error instead if needs be
  /// This will give conformer a more find tune way to modified stream behavior while it is running
  func didSend(request: URLRequest, received response: HTTPResponse) throws -> Single<HTTPResponse>
}
