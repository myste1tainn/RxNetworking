import Foundation
import Quick
import Nimble
import RxSwift
@testable import RxNetworking

final class HTTPClientSpec: QuickSpec {
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
      
      context("POST posts") {
        it("make request ok-ish") {
          let post = Post(id: 2, title: "hello world!", createdAt: Date())
          client.request(.posts(.post(post)))
                .expectation(bag: bag, { (response: HTTPResponse) in
                  expect(response.statusCode) > 199
                  expect(response.statusCode) < 300
                  expect(response.data).toNot(beNil())
                }, { (error: Error) in
                               expect(error).to(beNil())
                             })
        }
      }
      
      context("GET posts") {
        it("contains POSTed item") {
          client.request(.posts(.get))
                .expectation(bag: bag) {
                  expect($0.statusCode) > 199
                  expect($0.statusCode) < 300
                  let string = String(data: $0.data, encoding: .utf8)
                  expect(string).toNot(beNil())
                  expect(string).to(contain("\"id\": 2"))
                }
        }
      }
      
      context("DELETE posts") {
        it("remove specified item") {
          client.request(.posts(.delete("2")))
                .flatMap { _ in client.request(.posts(.get)) }
                .expectation(bag: bag) {
                  expect($0.statusCode) > 199
                  expect($0.statusCode) < 300
                  let string = String(data: $0.data, encoding: .utf8)
                  expect(string).toNot(beNil())
                  expect(string).toNot(contain("\"id\": 2"))
                }
        }
      }
    }
  }
  
  enum TestTarget: TargetType {
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
