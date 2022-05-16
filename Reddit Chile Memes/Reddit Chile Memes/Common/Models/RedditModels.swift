//
//  RedditModels.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import Foundation

enum RedditModels {
    
    // MARK: - BaseURL
    struct BaseURL {
        static func getBaseURL() -> String {
            return "https://www.reddit.com"
        }
    }
    
    
    // MARK: - Error
    enum Error {
        struct Request {
        }
        struct Response {
            var error: ErrorReddit
            var dismiss: Bool
            
            init(error: ErrorReddit, dismiss: Bool = false) {
                self.error = error
                self.dismiss = dismiss
            }
        }
        struct ViewModel {
            var error: ErrorReddit
            var dismiss: Bool
            
            init(error: ErrorReddit, dismiss: Bool = false) {
                self.error = error
                self.dismiss = dismiss
            }
        }
    }
}
