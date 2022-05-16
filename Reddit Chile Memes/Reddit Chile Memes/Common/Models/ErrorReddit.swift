//
//  ErrorReddit.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import Foundation

enum ErrorReddit: Error, CustomStringConvertible {
    case network(Int?, Data?, Error)
    case parse(Error)
    case unspecified
    case networkDescription(String)
    case parameters
    case errorInfo(String)
    
    var description: String {
        switch self {
        case .network( _, _, let error):
            return error.localizedDescription
        case .parse(let error):
            return error.localizedDescription
        case .unspecified:
            return "Unexpected error"
        case .networkDescription(let errorDescription):
            return errorDescription
        case .parameters:
            return "Error encoding parameters"
        case .errorInfo(let info):
            return info
        }
    }
}
