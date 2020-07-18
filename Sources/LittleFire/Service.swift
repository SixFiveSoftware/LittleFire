//
//  Service.swift
//  
//
//  Created by BJ Miller on 7/9/20.
//

import Foundation

public protocol Service {
  /// ResponseType is a type that is provided by a conforming Service as the type to be used when parsing the response.
  associatedtype ResponseType: ResponseDecodable

  var baseURL: String { get }
  var path: String { get }
  var parameters: [String: Any]? { get }
  var method: ServiceMethod { get }
  var body: Data? { get }
}

public extension Service {
  // MARK: default implementations
  var parameters: [String: Any]? { nil }
  var body: Data? { nil }

  // MARK: computed request
  var urlRequest: URLRequest {
    guard let url = url else { fatalError("URL could not be formed") }
    var request = URLRequest(url: url)
    request.httpMethod = method.methodName
    request.httpBody = body
    return request
  }

  // MARK: private
  private var formattedPath: String {
    path.starts(with: "/") ? path : "/" + path
  }

  private var url: URL? {
    var urlComponents = URLComponents(string: baseURL)
    urlComponents?.path = formattedPath

    if method == .get {
      if let params = parameters as? [String: String] {
        urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
      }
    }

    return urlComponents?.url
  }
}
