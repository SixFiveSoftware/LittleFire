//
//  ServiceProvider.swift
//  
//
//  Created by BJ Miller on 7/9/20.
//

import Foundation
import Combine

public enum LittleFireError: Error {
  case unknown
  case urlError(URLError)
  case decodingError(DecodingError)
}

public class ServiceProvider {
  let urlSession: URLSession

  public init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }

  @available(OSX 10.15, iOS 13, *)
  public func requestPublisher<ServiceType>(service: ServiceType)
  -> AnyPublisher<ServiceType.ResponseType, LittleFireError>
  where ServiceType: Service {

    urlSession.dataTaskPublisher(for: service.urlRequest)
      .retry(1)
      .map(\.data)
      .decode(type: ServiceType.ResponseType.self, decoder: ServiceType.ResponseType.decoder)
      .mapError(cast)
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  private func cast(error: Error) -> LittleFireError {
    if let urlError = error as? URLError {
      return .urlError(urlError)
    } else if let decodingError = error as? DecodingError {
      return .decodingError(decodingError)
    }
    return .unknown
  }
}
