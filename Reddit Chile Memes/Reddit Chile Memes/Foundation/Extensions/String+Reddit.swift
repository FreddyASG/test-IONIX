//
//  String+Reddit.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 15/5/22.
//

import Foundation

extension String {
    /// SwifterSwift: Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".localized -> Hallo Welt
    ///
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
