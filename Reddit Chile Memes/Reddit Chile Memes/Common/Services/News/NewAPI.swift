//
//  NewAPI.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import Foundation

class NewAPI: NewServiceProtocol {
    
    func fetchNews(request: New.FecthNews.Request,
                   completion: @escaping (Result<New.FecthNews.Response, ErrorReddit>) -> Void) {
        
        guard let parameters = try? request.asDictionary() else {
            completion(.failure(.parameters))
            return
        }
        
        NetworkService.share.cancelRequest(nil)
        NetworkService.share.request(endpoint: NotificationEndpoint.fetchNews(parameters: parameters)) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(New.FecthNews.Response.self, from: data)
                    completion(.success(response))
                } catch let error {
                    completion(.failure(.parse(error)))
                }
            case .failure(let errorReddit):
                completion(.failure(errorReddit))
            }
        }
    }
    
    func searchNews(request: New.SearchNews.Request,
                    completion: @escaping (Result<New.SearchNews.Response, ErrorReddit>) -> Void) {
        
        guard let parameters = try? request.asDictionary() else {
            completion(.failure(.parameters))
            return
        }
        
        NetworkService.share.cancelRequest(nil)
        NetworkService.share.request(endpoint: NotificationEndpoint.searchNews(parameters: parameters)) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(New.SearchNews.Response.self, from: data)
                    completion(.success(response))
                } catch let error {
                    completion(.failure(.parse(error)))
                }
            case .failure(let errorReddit):
                completion(.failure(errorReddit))
            }
        }
    }
}
