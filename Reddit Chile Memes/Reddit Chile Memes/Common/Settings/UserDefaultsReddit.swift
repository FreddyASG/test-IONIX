//
//  UserDefaultsReddit.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import Foundation

final class UserDefaultsReddit {
    struct Keys {
        static let hiddenCarousel = "hiddenCarousel"
    }
    
    static func isHiddenCarousel() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.hiddenCarousel)
    }
    
    static func hiddenCarousel(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.hiddenCarousel)
    }
}
