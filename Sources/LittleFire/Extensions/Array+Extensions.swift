//
//  Array+Extensions.swift
//  
//
//  Created by BJ Miller on 7/11/20.
//

import Foundation

/// Extends Array to conform to ResponseDecodable if the inner Element conforms to ResponseDecodable. This allows the generic
/// type passed into a Service object to be an array of a ResponseDecodable element, if the JSON happens to return an array.
extension Array: ResponseDecodable where Element: ResponseDecodable {
  public static var sampleJSON: String {
    "[]"
  }
}
