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

  public init() {}

  public func request<ServiceType>(service: ServiceType) -> Promise<ServiceType.ResponseType> where ServiceType: Service {
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

  @available(OSX 10.15, iOS 13, *)
  public func requestPublisher<ServiceType>(service: ServiceType)
  -> AnyPublisher<ServiceType.ResponseType, LittleFireError>
  where ServiceType: Service {

    urlSession.dataTaskPublisher(for: service.urlRequest)
      .map(\.data)
      .decode(type: ServiceType.ResponseType.self, decoder: ServiceType.ResponseType.decoder)
      .mapError(cast)
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  private func cast(error: Error) -> LittleFireError {
    .unknown // just return .unknown for now till error casting is built
  }

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
