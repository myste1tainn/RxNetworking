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
    return Single.create { [weak self] observer in
      guard let task = self?.createTask(target: target, observer: observer) else {
        return Disposables.create()
      }
      
      task.resume()
      
      return Disposables.create {
        task.cancel()
      }
    }
  }
  
  private func createTask(target: Target, observer: @escaping (SingleEvent<HTTPResponse>) -> Void) -> URLSessionTask {
    let session = URLSession(configuration: sessionConfiguration)
    let request = HTTPRequest(target: target)
    
    func completion(data: Data?, response: URLResponse?, error: Error?) {
      if let error = error {
        observer(.error(error))
      } else if let data = data, let response = response as? HTTPURLResponse {
        observer(.success(HTTPResponse(httpURLResponse: response, data: data)))
      }
    }
    
    switch target.task {
    case .plain:
      return session.dataTask(with: request.request, completionHandler: completion(data:response:error:))
    case .parametered(let parameters, let encoding):
      let newRequest = request.appending(parameters: parameters, encoding: encoding)
      return session.dataTask(with: newRequest, completionHandler: completion(data:response:error:))
    }
  }
}
