//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation
import RxSwift

open class HTTPClient<Target: TargetType> {
  
  var sessionConfiguration: URLSessionConfiguration
  var plugins: [PluginType]
  
  public init(
    sessionConfiguration: URLSessionConfiguration = .default,
    plugins: [PluginType] = []
  ) {
    self.sessionConfiguration = sessionConfiguration
    self.plugins = plugins
  }
  
  open func request(_ target: Target) -> Single<HTTPResponse> {
    return urlRequest(target: target).flatMap(send(request:))
  }
  
  private func send(request: URLRequest) -> Single<HTTPResponse> {
    let session = URLSession(configuration: sessionConfiguration)
    return Single<HTTPResponse>.create { observer in
      let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
        if let error = error {
          observer(.error(error))
        } else if let data = data, let response = response as? HTTPURLResponse {
          observer(.success(HTTPResponse(httpURLResponse: response, data: data)))
        }
      }
      
      task.resume()
      
      return Disposables.create {
        task.cancel()
      }
    }.flatMap(callingDelegateReceivedResponseFor(request: request))
  }
  
  private func callingDelegateReceivedResponseFor(request: URLRequest) -> (HTTPResponse) -> Single<HTTPResponse> {
    return { [weak self] response in
      guard let _self = self else { return Single.just(response) }
      return _self.plugins.reduce(Single.just(response)) { (single, plugin) in
        single.flatMap { try plugin.didSend(request: request, received: $0) }
      }
    }
  }
  
  private func urlRequest(target: Target) -> Single<URLRequest> {
    let request = HTTPRequest(target: target)
    
    /// Concatenate each of single from plugin into 1 stream with flatMap
    let urlRequestSingle = plugins.reduce(Single.just(request.urlRequest)) { (single, plugin) in
      single.flatMap { try plugin.willSend(httpRequest: request, request: $0) }
    }
    
    return urlRequestSingle
  }
}
