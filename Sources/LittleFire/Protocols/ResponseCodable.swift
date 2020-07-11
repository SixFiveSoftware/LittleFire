//
//  ResponseCodable.swift
//  
//
//  Created by BJ Miller on 7/9/20.
//

import Foundation

public protocol ResponseCodable: RequestEncodable & ResponseDecodable {}

public protocol RequestEncodable: Encodable {}

public protocol ResponseDecodable: Decodable {
  /// sampleJSON used to supply json to decode into a sampleInstance()
  static var sampleJSON: String { get }

  /// decoder used to decode an instance of self from Data
  static var decoder: JSONDecoder { get }

  /// defaultValue used to provide a default value from a REST response if there was a failure parsing the response into self.
  /// For instance, the server may return `{}`, but what you need is `{ "result": [] }`.
  /// ResponseDecodable extension default implementation returns `nil`, as not many types may need to implement this.
  static var defaultValue: Self? { get }
}

public extension ResponseDecodable {

  static var sampleData: Data { sampleJSON.data(using: .utf8)! }

  static var decoder: JSONDecoder { .defaultDecoder }

  static func sampleInstance() -> Self? {
    do {
      let obj = try decoder.decode(Self.self, from: sampleData)
      return obj
    } catch {
      print("Failed to parse sampleInstance for type: \(String(describing: Self.self))")
      print("Error: \(error.localizedDescription)")
      return nil
    }
  }

  static var defaultValue: Self? { nil }

  static func decode(from data: Data) -> Self? {
    try? Self.decoder.decode(Self.self, from: data)
  }
}

public extension RequestEncodable {

  var encoder: JSONEncoder { .defaultEncoder }

  func asData() -> Data? {
    try? encoder.encode(self)
  }
}
