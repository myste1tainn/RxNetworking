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
    
    case profile(_ method: Method)
    case posts(_ method: Method)
    case comments(_ method: Method)
    
    static var authenticationType = AuthorizationType.basic
    
    static var authenticationHeader = "Authorization"
    
    var authorizationHeader: String {
      return type(of: self).authorizationHeader
    }
    
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
    
    var method: HTTPMethod {
      switch self {
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
    
    static var authenticationType = AuthorizationType.basic
    
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
    
    var method: HTTPMethod {
      switch self {
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
    var id: Int?
    var title: String?
    var createdAt: Date?
    
    enum CodingKeys: CodingKey {
      case id
      case title
      case createdAt
    }
  }
}
