//
//  StringExtensions.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 22/12/2020.
//

import Foundation

let languageKey = "languageKey"

extension String {
    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")

    public func convertedToSlug() -> String? {
        if let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
            let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
            let result = urlComponents.filter { $0 != "" }.joined(separator: "-")

            if result.count > 0 {
                return result
            }
        }
        return nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return text.filter {okayChars.contains($0) }
    }
    
    func localizedLanguage() -> String? {
        var defaultLanguage = "English"
        if let selectedLanguage = UserDefaults.standard.string(forKey: languageKey) {
            defaultLanguage = selectedLanguage
        }
        return NSLocalizedString(self, tableName: defaultLanguage, comment: "")
    }
}
