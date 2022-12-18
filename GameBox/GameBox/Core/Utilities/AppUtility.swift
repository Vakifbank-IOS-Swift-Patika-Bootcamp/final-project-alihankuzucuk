//
//  AppUtility.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 16.12.2022.
//

import Foundation

// MARK: - AppUtility
final class AppUtility {
    
    static var availableLanguages: [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    @discardableResult
    static func setApplicationLanguage(languageCode: String) -> Bool {
        guard availableLanguages.contains(where: {
            $0.hasPrefix(languageCode)
        }) else { return false }
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        return true
    }
    
}
