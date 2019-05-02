import Foundation
import Quick
import Nimble
import RxSwift
@testable import RxNetworking

final class HTTPClientAccessTokenAuthorizableSpec: QuickSpec {
  override func spec() {
    // TODO: killall is too drastic, will have to find it's pid and kill it that way.
    shell("killall", "-9", "node")
    shell("rm", "-rf", "db.json")
    exec("json-server", "db.json")
    sleep(1)
    var client: HTTPClient<TestTarget>!
    let bag = DisposeBag()
    describe("HTTPClient") {
      beforeEach { client = .init() }
      
      
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
    
    var authenticationType: AuthenticationType {
      return .bearer
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
