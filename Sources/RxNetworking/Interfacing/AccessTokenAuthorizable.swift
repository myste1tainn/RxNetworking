//
// Created by Arnon Keereena on 2019-05-01.
//

import Foundation

public protocol AccessTokenAuthorizable: TargetType {
  var authorizationHeader: String { get }
  var authorizationType:   AuthorizationType { get }
}

public extension AccessTokenAuthorizable {
  public var authorizationHeader: String {
    return "Authorization"
  }
}
