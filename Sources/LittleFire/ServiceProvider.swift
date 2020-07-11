//
//  ServiceProvider.swift
//  
//
//  Created by BJ Miller on 7/9/20.
//

import Foundation
import PromiseKit
import Combine

public enum LittleFireError: Error {
  case unknown
}

public class ServiceProvider {
  let urlSession = URLSession.shared

  func request<ServiceType>(service: ServiceType) -> Promise<ServiceType.ResponseType> where ServiceType: Service {
    perform(service.urlRequest)
      .then { (data) -> Promise<ServiceType.ResponseType> in
        do {
          let object = try ServiceType.ResponseType.decoder.decode(ServiceType.ResponseType.self, from: data)
          return .value(object)
        } catch {
          throw error
        }
      }
  }

}

extension ServiceProvider {
  private func perform(_ request: URLRequest) -> Promise<Data> {
    Promise { seal in
      urlSession.dataTask(with: request) { data, _, error in
        if let err = error {
          seal.reject(err)
        } else if let data = data {
          seal.fulfill(data)
        } else {
          seal.reject(LittleFireError.unknown)
        }
      }.resume()
    }
  }
}
