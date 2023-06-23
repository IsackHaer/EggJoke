//
//  TranslationResponse.swift
//  EggJoke
//
//  Created by Isack Häring on 21.06.23.
//

import Foundation

struct TranslationResponse: Codable {
    let translations : [Translation]
}

extension TranslationResponse {
    struct Translation: Codable {
        let detected_source_language: String
        let text: String
    }
}
