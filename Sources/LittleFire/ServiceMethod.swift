//
//  ServiceMethod.swift
//  
//
//  Created by BJ Miller on 7/9/20.
//

import Foundation

public enum ServiceMethod: String {
  case get
  case post
  case put
  case delete
  case patch
  case options
  case head
  case trace
  case connect

  var methodName: String { rawValue.uppercased() }
}
