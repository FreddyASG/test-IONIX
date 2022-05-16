//
//  NewEndpoint.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import Foundation
import Alamofire

enum NotificationEndpoint {
    case fetchNews(parameters: Parameters)
    case searchNews(parameters: Parameters)
}

extension NotificationEndpoint: IEndpoint {
    var method: HTTPMethod {
        switch self {
        case .fetchNews, .searchNews:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchNews:
            return "\(RedditModels.BaseURL.getBaseURL())/r/chile/new/.json"
        case .searchNews:
            return "\(RedditModels.BaseURL.getBaseURL())/r/chile/search.json"
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .fetchNews(let parameters), .searchNews(let parameters):
            return parameters
        }
    }
    
    var header: HTTPHeaders? {
        switch self {
        case .fetchNews, .searchNews:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .fetchNews, .searchNews:
            return URLEncoding.default
        }
    }
    
    var interceptor: RequestInterceptor? {
        nil
    }
    
}
