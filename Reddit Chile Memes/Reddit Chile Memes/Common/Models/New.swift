//
//  New.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import Foundation

enum New {
  
    // MARK: Use cases
    enum FecthNews {
        struct Request: Codable {
            let limit: Int
            let after: String?
        }
        struct Response: Codable {
            let kind: String?
            let data: ResponseData?
        }
        struct ViewModel {
        }
    }
    
    enum SearchNews {
        struct Request: Codable {
            let limit: Int
            let after: String?
            let query: String?
            
            enum CodingKeys: String, CodingKey {
                case limit = "limit"
                case after = "after"
                case query = "q"
            }
        }
        struct Response: Codable {
            let kind: String?
            let data: ResponseData?
        }
        struct ViewModel {
        }
    }
    
    // MARK: - ResponseData
    struct ResponseData: Codable {
        let after: String?
        let dist: Int?
        let modhash: String?
        let geoFilter: String?
        let children: [Child]?
        let before: String?

        enum CodingKeys: String, CodingKey {
            case after = "after"
            case dist = "dist"
            case modhash = "modhash"
            case geoFilter = "geo_filter"
            case children = "children"
            case before = "before"
        }
    }

    // MARK: - Child
    struct Child: Codable {
        let kind: String?
        let data: ChildData?
    }

    // MARK: - ChildData
    struct ChildData: Codable {
        let title: String?
        let name: String?
        let linkFlairText: String?
        let score: Int?
        let postHint: String?
        let numComments: Int?
        let url: String?

        enum CodingKeys: String, CodingKey {
            case title = "title"
            case name = "name"
            case linkFlairText = "link_flair_text"
            case score = "score"
            case postHint = "post_hint"
            case numComments = "num_comments"
            case url = "url"
        }
    }

}
