//
// Created by Arnon Keereena on 2019-04-30.
//

import Foundation
import RxSwift
import Nimble

extension Observable {
  func expectation(timeout: TimeInterval = 9999, bag: DisposeBag, _ assertion: @escaping (E) -> Void) {
    waitUntil(timeout: timeout) { done in
      self.subscribe(
            onNext: { assertion($0) },
            onError: { expect($0).to(beNil()) },
            onCompleted: done
          )
          .disposed(by: bag)
    }
  }
  
  func expectation(timeout: TimeInterval = 9999,
                   bag: DisposeBag,
                   _ assertion: @escaping (E) -> Void,
                   _ errorAssertion: @escaping (Error) -> Void) {
    waitUntil(timeout: timeout) { done in
      self.subscribe(
            onNext: { assertion($0) },
            onError: { errorAssertion($0) },
            onCompleted: done
          )
          .disposed(by: bag)
    }
  }
}
