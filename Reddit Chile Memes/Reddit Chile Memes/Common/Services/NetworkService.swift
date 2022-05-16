//
//  NetworkService.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import Foundation
import Alamofire

protocol IEndpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: Parameters? { get }
    var header: HTTPHeaders? { get }
    var interceptor: RequestInterceptor? { get }
    var encoding: ParameterEncoding { get }
}

class NetworkService {
    static let share = NetworkService()
    
    private var dataRequest: DataRequest?
    
    @discardableResult
    private func _dataRequest(url: URLConvertible,
                              method: HTTPMethod = .get,
                              parameters: Parameters? = nil,
                              encoding: ParameterEncoding = URLEncoding.default,
                              headers: HTTPHeaders? = nil,
                              interceptor: RequestInterceptor? = nil) -> DataRequest {
        
            return Session.default.request(url,
                                           method: method,
                                           parameters: parameters,
                                           encoding: encoding,
                                           headers: headers,
                                           interceptor: interceptor)
    }
    
    func request<T: IEndpoint>(endpoint: T, completion: @escaping (Swift.Result<Data, ErrorReddit>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.dataRequest = self._dataRequest(url: endpoint.path,
                                            method: endpoint.method,
                                            parameters: endpoint.parameter,
                                            encoding: endpoint.encoding,
                                            headers: endpoint.header,
                                            interceptor: endpoint.interceptor)
            
            self.dataRequest?
                .validate()
                .response(completionHandler: { (response) in
                    
                    switch response.result {
                    case .success(let data):
                        guard let data = data else {
                            completion(.failure(.network(nil,
                                                         nil,
                                                         AFError.responseValidationFailed(reason: .dataFileNil))))
                            return
                        }
                        
                        completion(.success(data))
                    case .failure(let error):
                        if !error.isExplicitlyCancelledError {
                            guard let data = response.data, let statusCode = response.response?.statusCode else {
                                completion(.failure(.network(nil,
                                                             nil,
                                                             error)))
                                return
                            }
                            
                            completion(.failure(.network(statusCode, data, error)))
                        }
                    }
            })
        }
    }
    
    func cancelRequest(_ completion: (()->Void)? = nil) {
        dataRequest?.cancel()
        completion?()
    }
}
