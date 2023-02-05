//
//  TranslatorData.swift
//  SeeFood
//
//  Created by Marina Karpova on 05.02.2023.
//

import Foundation

struct TranslatorData: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let translations: Translations
}

// MARK: - Translations
struct Translations: Codable {
    let translatedText: String
}
