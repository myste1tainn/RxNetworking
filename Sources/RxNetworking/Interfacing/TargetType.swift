//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

public protocol TargetType {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var task: Task { get }
}
