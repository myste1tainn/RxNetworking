import Quick
import Nimble
@testable import RxNetworking

final class URLQueryEncoderSpec: QuickSpec {
  
  override func spec() {
    var encoder: URLQueryEncoder!
    describe("URLQueryEncoder") {
      
      beforeEach { encoder = .init() }
      
      context("#encode") {
        
        context("simple parameter") {
          var result: String!
          beforeEach {
            let parameters = Parameters.init(firstname: "A", lastname: "K")
            result = try! encoder.encode(parameters)
          }
  
          it("returns query string") {
            expect(result) == "?firstname=A&lastname=K"
          }
        }
        
        context("nested parameters") {
          var result: String!
          beforeEach {
            let parameters = NestedParameters(age: 10,
                                              birthDate: "2019/03/1990",
                                              user: .init(firstname: "A", lastname: "K"))
            result = try! encoder.encode(parameters)
          }
    
          it("returns flatten query string") {
            expect(result) == "?age=10&birthDate=2019%2F03%2F1990&firstname=A&lastname=K"
          }
        }
        
      }
    }
  }
  
  struct Parameters: Encodable {
    var firstname: String
    var lastname: String
    
    enum CodingKeys: CodingKey {
      case firstname
      case lastname
    }
  }
  
  struct NestedParameters: Encodable {
    var age: Int
    var birthDate: String
    var user: Parameters
    
    enum CodingKeys: CodingKey {
      case age
      case birthDate
      case user
    }
  }
}
