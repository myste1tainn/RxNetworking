//
// Created by Arnon Keereena on 2019-04-26.
//

import Foundation

extension StringMapEncoding {
  final class Data {
    
    private(set) var maps: [String: String] = [:]
    
    func encode(key codingKey: CodingKey, value: String) {
      maps[codingKey.stringValue] = value
    }
    
    func encode(keys codingKeys: [CodingKey], value: String) {
      codingKeys.forEach { self.encode(key: $0, value: value) }
    }
  }
}

