import Foundation
import Quick
import Nimble
import RxSwift
@testable import RxNetworking

final class HTTPRequestSpec: QuickSpec {
  override func spec() {
    var httpRequest: HTTPRequest!
    describe("HTTPRequest") {
      
      context("target is TargetType") {
      
      }
      
      context("target is form-data") {
        beforeEach {
          httpRequest = .init(target: CustomHeaderAuthorizableTarget.accessToken)
        }
        
        describe("#urlReqeust") {
          it("add form-data content-type") {
            let request = httpRequest.urlRequest
            expect(request.allHTTPHeaderFields?.keys).to(contain("Content-Type"))
            let header = request.allHTTPHeaderFields?.first { $0.key == "Content-Type" }
            expect(header?.value).to(contain("multipart/form-data; boundary="))
          }
        }
      }
    }
    
    context("target is AccessTokenAuthorizable") {
      
      beforeEach {
        httpRequest = .init(target: AuthorizableTarget.posts(.get))
      }
      
      describe("#urlRequest") {
        
        context("required basic auth") {
          beforeEach {
            AuthorizableTarget.authorizationType = .basic
          }
          
          it("add authorization basic to header") {
            let request = httpRequest.urlRequest
            expect(request.allHTTPHeaderFields?.keys).to(contain("Authorization"))
            let header = request.allHTTPHeaderFields?.first { $0.key == "Authorization" }
            expect(header?.value).to(contain("Basic "))
          }
          
        }
        
        context("required bearer auth") {
          beforeEach {
            AuthorizableTarget.authorizationType = .bearer
          }
          
          it("add authorization basic to header") {
            let request = httpRequest.urlRequest
            expect(request.allHTTPHeaderFields?.keys).to(contain("Authorization"))
            let header = request.allHTTPHeaderFields?.first { $0.key == "Authorization" }
            expect(header?.value).to(contain("Bearer "))
          }
          
        }
        
        context("required custom value auth") {
          beforeEach {
            AuthorizableTarget.authorizationType = .custom("Prefix")
          }
          
          it("add authorization basic to header") {
            let request = httpRequest.urlRequest
            expect(request.allHTTPHeaderFields?.keys).to(contain("Authorization"))
            let header = request.allHTTPHeaderFields?.first { $0.key == "Authorization" }
            expect(header?.value).to(contain("Prefix "))
          }
          
        }
        
        context("required custom empty auth") {
          beforeEach {
            AuthorizableTarget.authorizationType = .custom("")
          }
          
          it("add authorization basic to header") {
            let request = httpRequest.urlRequest
            expect(request.allHTTPHeaderFields?.keys).to(contain("Authorization"))
            let header = request.allHTTPHeaderFields?.first { $0.key == "Authorization" }
            expect(header?.value) == ""
          }
          
        }
        
        
      }
      
      context("target is CustomHeaderAccessTokenAuthorizable") {
        
        let headerKey = "X-Custom-Header"
        beforeEach {
          CustomHeaderAuthorizableTarget.authorizationHeader = headerKey
          httpRequest = .init(target: CustomHeaderAuthorizableTarget.posts(.get))
        }
        
        describe("#urlRequest") {
          
          context("required basic auth") {
            beforeEach {
              CustomHeaderAuthorizableTarget.authorizationType = .basic
            }
            
            it("add authorization basic to header") {
              let request = httpRequest.urlRequest
              expect(request.allHTTPHeaderFields?.keys).to(contain(headerKey))
              let header = request.allHTTPHeaderFields?.first { $0.key == headerKey }
              expect(header?.value).to(contain("Basic "))
            }
            
          }
          
          context("required bearer auth") {
            beforeEach {
              CustomHeaderAuthorizableTarget.authorizationType = .bearer
            }
            
            it("add authorization basic to header") {
              let request = httpRequest.urlRequest
              expect(request.allHTTPHeaderFields?.keys).to(contain(headerKey))
              let header = request.allHTTPHeaderFields?.first { $0.key == headerKey }
              expect(header?.value).to(contain("Bearer "))
            }
            
          }
          
          context("required custom value auth") {
            beforeEach {
              CustomHeaderAuthorizableTarget.authorizationType = .custom("Prefix")
            }
            
            it("add authorization basic to header") {
              let request = httpRequest.urlRequest
              expect(request.allHTTPHeaderFields?.keys).to(contain(headerKey))
              let header = request.allHTTPHeaderFields?.first { $0.key == headerKey }
              expect(header?.value).to(contain("Prefix "))
            }
            
          }
          
          context("required custom empty auth") {
            beforeEach {
              CustomHeaderAuthorizableTarget.authorizationType = .custom("")
            }
            
            it("add authorization basic to header") {
              let request = httpRequest.urlRequest
              expect(request.allHTTPHeaderFields?.keys).to(contain(headerKey))
              let header = request.allHTTPHeaderFields?.first { $0.key == headerKey }
              expect(header?.value) == ""
            }
            
          }
        }
        
      }
      
    }
  }
  
  
  enum AuthorizableTarget: AccessTokenAuthorizable {
    enum Method {
      case get
      case put(_ id: String)
      case post(_ body: Encodable)
      case delete(_ id: String)
      
      var httpMethod: HTTPMethod {
        switch self {
        case .get: return .get
        case .put: return .put
        case .post: return .post
        case .delete: return .delete
        }
      }
    }
    
    case profile(_ method: Method)
    case posts(_ method: Method)
    case comments(_ method: Method)
    
    static var authorizationType = AuthorizationType.basic
    
    var authorizationType: AuthorizationType {
      return type(of: self).authorizationType
    }
    
    var baseURL: URL {
      return URL(string: "http://localhost:3000")!
    }
    
    var pathName: String {
      switch self {
      case .profile: return "profile"
      case .posts: return "posts"
      case .comments: return "comments"
      }
    }
    
    var path: String {
      let base = pathName
      switch self {
      case .profile(let method),
           .posts(let method),
           .comments(let method):
        switch method {
        case .get, .post: return base
        case .delete(let id), .put(let id): return "\(base)/\(id)"
        }
      }
    }
    
    var method:  HTTPMethod {
      switch self {
      case .profile(let method),
           .comments(let method),
           .posts(let method): return method.httpMethod
      }
    }
    var headers: [String: String] {
      return [:]
    }
    var task:    Task {
      switch self {
      case .profile(let method),
           .comments(let method),
           .posts(let method):
        switch method {
        case .get: return .plain
        case .post(let body): return .parametered(with: body, encoding: .body(contentType: .json))
        default: return .plain
        }
      }
    }
  }
  
  struct Post: Encodable {
    var id:        Int?
    var title:     String?
    var createdAt: Date?
    
    enum CodingKeys: CodingKey {
      case id
      case title
      case createdAt
    }
  }
  
}

enum CustomHeaderAuthorizableTarget: AccessTokenAuthorizable {
  enum Method {
    case get
    case put(_ id: String)
    case post(_ body: Encodable)
    case delete(_ id: String)
    
    var httpMethod: HTTPMethod {
      switch self {
      case .get: return .get
      case .put: return .put
      case .post: return .post
      case .delete: return .delete
      }
    }
  }
  
  case accessToken
  case profile(_ method: Method)
  case posts(_ method: Method)
  case comments(_ method: Method)
  
  static var authorizationType = AuthorizationType.basic
  
  static var authorizationHeader = "Authorization"
  
  var authorizationHeader: String {
    return type(of: self).authorizationHeader
  }
  
  var authorizationType: AuthorizationType {
    switch self {
    case .accessToken: return .none
    default: return type(of: self).authorizationType
    }
  }
  
  var baseURL: URL {
    switch self {
    case .accessToken: return URL(string: "http://testapi.mycloudfulfillment.com")!
    default: return URL(string: "http://localhost:3000")!
    }
  }
  
  var pathName: String {
    switch self {
    case .accessToken: return ""
    case .profile: return "profile"
    case .posts: return "posts"
    case .comments: return "comments"
    }
  }
  
  var path: String {
    let base = pathName
    switch self {
    case .accessToken: return "api/v1/gettoken"
    case .profile(let method),
         .posts(let method),
         .comments(let method):
      switch method {
      case .get, .post: return base
      case .delete(let id), .put(let id): return "\(base)/\(id)"
      }
    }
  }
  
  var method:  HTTPMethod {
    switch self {
    case .accessToken: return .post
    case .profile(let method),
         .comments(let method),
         .posts(let method): return method.httpMethod
    }
  }
  var headers: [String: String] {
    return [:]
  }
  
  var task: Task {
    switch self {
    case .accessToken:
      let id     = "53808f0e5cb54e118ad8296a28a34b92"
      let secret = "cdd1c91bd6a544289763c19376fa2e7e135964321b064361"
      return .parametered(with: AccessTokenRequest(id: id, secret: secret),
                          encoding: .body(contentType: .form(.data)))
    case .profile(let method),
         .comments(let method),
         .posts(let method):
      switch method {
      case .get: return .plain
      case .post(let body): return .parametered(with: body, encoding: .body(contentType: .json))
      default: return .plain
      }
    }
  }
}

struct AccessTokenRequest: Encodable {
  var id:     String
  var secret: String
  
  enum CodingKeys: String, CodingKey {
    case id     = "apikey"
    case secret = "secretkey"
  }
}
