//
//  NinjaJokeModel.swift
//  EggJoke
//
//  Created by Isack Häring on 23.06.23.
//

import Foundation


struct NinjaJokeResponse: Codable {
    var jokeList: [NinjaJoke]
}

extension NinjaJokeResponse{
    struct NinjaJoke: Codable, Hashable {
        let joke: String
    }
}
