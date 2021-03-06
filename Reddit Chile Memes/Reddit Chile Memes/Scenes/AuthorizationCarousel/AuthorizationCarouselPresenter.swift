//
//  AuthorizationCarouselPresenter.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 15/5/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AuthorizationCarouselPresentationLogic {
    func presentInitialData(response: AuthorizationCarousel.InitialData.Response)
}

class AuthorizationCarouselPresenter: AuthorizationCarouselPresentationLogic {
    weak var viewController: AuthorizationCarouselDisplayLogic?
  
    // MARK: - presentInitialData
    func presentInitialData(response: AuthorizationCarousel.InitialData.Response) {
        let viewModel = AuthorizationCarousel.InitialData.ViewModel(items: response.items)
        viewController?.displayInitialData(viewModel: viewModel)
    }
}
