//
//  JSONDecoder+Extensions.swift
//  
//
//  Created by BJ Miller on 7/9/20.
//

import Foundation

public extension JSONDecoder {
  static var defaultDecoder: JSONDecoder {
    let dec = JSONDecoder()
    dec.keyDecodingStrategy = .convertFromSnakeCase
    return dec
  }
}
