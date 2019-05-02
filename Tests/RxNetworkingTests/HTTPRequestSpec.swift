import Foundation
import Quick
import Nimble
import RxSwift
@testable import RxNetworking

final class HTTPRequestSpec: QuickSpec {
  override func spec() {
    var request: HTTPRequest!
    let bag = DisposeBag()
    describe("HTTPClient") {
      beforeEach { client = .init() }
      
      context("when target required basic authentication") {
        var request: URLRequest!
        
        beforeEach {
          TestTarget.authenticationType = .basic
        }
        
        context("#composeRequest") {
          
          beforeEach {
            request = client.composeRequest()
          }
          
          it("add authorization basic to header") {
            expect(request.allHTTPHeaderFields?.keys).to(contain("Authorization"))
            let header = request.allHTTPHeaderFields?.first { $0.key == "Authorization" }
            expect(header?.value).to(contain("Basic"))
          }
          
        }
        
      }
      
      context("when target required custom authentication") {
        
      }
    }
  }
  
  enum TestTarget: AccessTokenAuthorizable {
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
    
    static var authenticationType = AuthenticationType.basic
    
    var authenticationType: AuthenticationType {
      return type(of: self).authenticationType
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
