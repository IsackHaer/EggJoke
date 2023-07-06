//
//  TranslationView++.swift
//  EggJoke
//
//  Created by Isack Häring on 06.07.23.
//

import Foundation

extension TranslationView {
    enum Language: String, CaseIterable, Identifiable {
        case Bulgarian = "BG"
        case Czech = "CS"
        case Danish = "DA"
        case German = "DE"
        case Greek = "EL"
        case English = "EN"
        case Spanish = "ES"
        case Estonian = "ET"
        case Finnish = "FI"
        case French = "FR"
        case Hungarian = "HU"
        case Indonesian = "ID"
        case Italian = "IT"
        case Japanese = "JA"
        case Korean = "KO"
        case Lithuanian = "LT"
        case Latvian = "LV"
        case Norwegian = "NB"
        case Dutch = "NL"
        case Polish = "PL"
        case Portuguese = "PT"
        case Romanian = "RO"
        case Russian = "RU"
        case Slovak = "SK"
        case Slovenian = "SL"
        case Swedish = "SV"
        case Turkish = "TR"
        case Ukrainian = "UK"
        case Chinese = "ZH"
        var id: Self { self }
    }
}
