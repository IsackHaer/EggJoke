//
//  JokeCard++.swift
//  EggJoke
//
//  Created by Isack Häring on 03.07.23.
//

import Foundation

extension JokeCard {
    func wordArray(joke: String) -> [String] {
        return joke.components(separatedBy: " ")
    }
}
