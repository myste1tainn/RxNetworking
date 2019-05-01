//
// Created by Arnon Keereena on 2019-05-01.
//

import Foundation

public protocol AccessTokenAuthorizable: TargetType {
  var authenticationHeader: String { get }
  var authenticationType: AuthenticationType { get }
}

extension AccessTokenAuthorizable {
  var authenticationHeader: String {
    return "Authorization"
  }
}
