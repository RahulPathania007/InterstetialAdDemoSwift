//
//  LanguageManager.swift
//  Localization Demo
//
//  Created by Sunfocus Solutions on 22/02/24.
//

import Foundation

class LanguageManager {
    static let selectedLanguageKey = "selectedLanguage"

    static func saveSelectedLanguage(_ selectedLang: Language) {
        let rawValue = selectedLang.rawValue
        UserDefaults.standard.set(rawValue, forKey: selectedLanguageKey)
    }

    static func getSelectedLanguage() -> Language {
        if let savedLanguage = UserDefaults.standard.string(forKey: selectedLanguageKey),
           let selectedLang = Language(rawValue: savedLanguage) {
            return selectedLang
        } else {
            return Language.english
        }
    }
}
