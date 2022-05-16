//
//  BaseViewController.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil, handlerAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handlerAction))
        
        present(alert, animated: true, completion: completion)
    }
}
