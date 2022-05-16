//
//  HomePresenter.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomePresentationLogic {
    func presentPosts(response: Home.Posts.Response)
    func presentError(response: RedditModels.Error.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
  
    // MARK: - presentPosts
    func presentPosts(response: Home.Posts.Response) {
        
        let posts = response.news.filter { new in
            return new.data?.linkFlairText == "Shitposting" && new.data?.postHint == "image"
        }
        
        let viewModel = Home.Posts.ViewModel(posts: posts)
        viewController?.displayPosts(viewModel: viewModel)
    }
    
    // MARK: - presentError
    func presentError(response: RedditModels.Error.Response) {
        let viewModel = RedditModels.Error.ViewModel(error: response.error)
        viewController?.displayError(viewModel: viewModel)
    }
}
